// Invitations
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Garden
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

/// Deletes the [Invitation] record corresponding to [invitation]
/// and creates a new [AppUserGardenRecord] record for the currentUser
/// and the [Garden] of invitation.
Future<void> acceptInvitationAndCreateUserGardenRecord(
  Invitation invitation, {
  required void Function() callback,
}) async {

  // Delete Invitation
  await deleteInvitation(invitation.id);

  // Create UserGardenRecord
  await GetIt.instance<UserGardenRecordsRepository>().create(
    body: {
      UserGardenRecordField.garden: invitation.garden.id,
      UserGardenRecordField.role: AppUserGardenRole.member.name,
      UserGardenRecordField.user: GetIt.instance<AppState>().currentUser!.id,
    }
  );

  callback();
}

/// An action. Attempts to create a new [Invitation] record with the values passed in
/// [map].
///
/// Returns the created [RecordModel] and an empty map if created successfully,
/// else null and a map of the errors.
Future<(RecordModel?, Map?)> createInvitation(
  BuildContext context,
  Map<String, dynamic> map
) async {
  try {
    // Check permissions
    await GetIt.instance<AppState>().verify([AppUserGardenPermission.createInvitations]);

    // Open Invitation
    if (map[InvitationField.type] == InvitationType.open.name) {
      map[InvitationField.invitee] = null;
      map[InvitationField.uuid] = Uuid().v1();
    }

    // Private Invitation
    if (map[InvitationField.type] == InvitationType.private.name) {
      final username = map[InvitationField.invitee];
      final gardenID = map[InvitationField.garden];

      final userGardenRecordsBackRelation = ""
        "${Collection.userGardenRecords}_via_${UserGardenRecordField.user}"
        ".${UserGardenRecordField.garden}";

      final invitationsInviteeBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.invitee}"
        ".${UserField.username}";

      final invitationsExpiryDateBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.expiryDate}";

      final formattedDate = DateFormat(Formats.dateYMMdd).format(DateTime.now());
      final resultList = await GetIt.instance<UsersRepository>().getList(
        filter: ""
          "${UserField.username} = '$username' && " // username matches
          "$userGardenRecordsBackRelation != '$gardenID' && " // not a member of this Garden
          "($invitationsInviteeBackRelation != '$username' || "
          "$invitationsExpiryDateBackRelation < '$formattedDate')" // not already an active invitation to this Garden
      );

      if (resultList.items.isEmpty) {
        return (
          null,
          {InvitationField.invitee: AdminInvitationViewText.createInvitationError}
        );
      } else {
        map[InvitationField.uuid] = null;

        // Change "invitee" value to be the valid userID (from the username)
        map[InvitationField.invitee] = resultList.items.first.toJson()[GenericField.id];
      }
    }

    // Create
    final (record, errorsMap) = await GetIt.instance<InvitationsRepository>().create(
      body: map,
    );

    return (record, errorsMap);
  } on PermissionException {
    if (context.mounted) {
      // Redirect to UnauthorizedPage
      GoRouter.of(context).go(
        Uri(
          path: Routes.unauthorized,
          queryParameters: {QueryParameters.previousRoute: Routes.garden}
        ).toString()
      );
    }

    return (null, null);
  }
}

/// Deletes the [Invitation] record with the given [invitationID].
Future<void> deleteInvitation(
  String invitationID, {
  void Function()? callback,
}) async {
  // Delete
  await GetIt.instance<InvitationsRepository>().delete(id: invitationID);

  if (callback != null) callback();
}

/// An action. Queries on the [Invitation] collection to retrieve all non-expired records
/// with the same [Garden] as currentGarden.
///
/// Returns a map of retrieved [Invitation]s.
Future<Map<InvitationType, List<Invitation>>> getCurrentGardenInvitations(
  BuildContext context, {
  DateTime? expiryDateThreshold, // primarily for testing
}) async {
  try {
    // Check permissions
    await GetIt.instance<AppState>().verify(
      [AppUserGardenPermission.viewActiveInvitations]
    );

    final List<Invitation> openInvitations = [];
    final List<Invitation> privateInvitations = [];

    final currentGarden = GetIt.instance<AppState>().currentGarden!;

    final expiryDateThresholdString =
      DateFormat(Formats.dateYMMddHHms).format(expiryDateThreshold ?? DateTime.now());

    final resultList = await GetIt.instance<InvitationsRepository>().getList(
      expand: "${InvitationField.creator}, ${InvitationField.invitee}",
      filter: ""
        "${InvitationField.garden} = '${currentGarden.id}' "
        "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
      sort: GenericField.created
    );

    for (final record in resultList.items) {
      AppUser? invitee;
      final recordJson = record.toJson();

      final type = getInvitationTypeFromString(recordJson[InvitationField.type])!;

      final creatorRecord = recordJson[QueryKey.expand][InvitationField.creator];
      final creator = AppUser.fromJson(creatorRecord);

      switch (type) {
        case InvitationType.open:
          openInvitations.add(
            Invitation.fromJson(recordJson, creator, currentGarden, invitee)
          );
        case InvitationType.private:
          recordJson[InvitationField.uuid] = null;

          final inviteeRecord = recordJson[QueryKey.expand][InvitationField.invitee];
          invitee = AppUser.fromJson(inviteeRecord);

          privateInvitations.add(
            Invitation.fromJson(recordJson, creator, currentGarden, invitee)
          );
      }
    }

    return {
      InvitationType.open: openInvitations,
      InvitationType.private: privateInvitations
    };
  } on PermissionException {
    if (context.mounted) {
      // Redirect to UnauthorizedPage
      GoRouter.of(context).go(
        Uri(
          path: Routes.unauthorized,
          queryParameters: { QueryParameters.previousRoute: Routes.garden }
        ).toString()
      );
    }

    return {
      InvitationType.open: [],
      InvitationType.private: []
    };
  }
}

/// Queries on the [Invitation] collection to retrieve the records with a matching
/// invitee value, and expiryDate greater than [expiryDateThreshold].
Future<List<Invitation>> getInvitationsByInvitee(
  String inviteeID, {
  DateTime? expiryDateThreshold, // primarily for testing
}) async {
  final List<Invitation> invitationsList = [];

  final expiryDateThresholdString =
      DateFormat(Formats.dateYMMddHHms).format(expiryDateThreshold ?? DateTime.now());

  // Get Invitation records
  final resultList = await GetIt.instance<InvitationsRepository>().getList(
    expand: ""
      "${InvitationField.creator}, ${InvitationField.invitee}, ${InvitationField.garden}",
    filter: ""
      "${InvitationField.invitee} = '$inviteeID' "
      "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
    sort: "${GenericField.created}, ${InvitationField.expiryDate}",
  );

  for (final record in resultList.items) {
    final recordJson = record.toJson();

    final creatorRecord = recordJson[QueryKey.expand][InvitationField.creator];
    final creator = AppUser.fromJson(creatorRecord);

    final inviteeRecord = recordJson[QueryKey.expand][InvitationField.invitee];
    final invitee = AppUser.fromJson(inviteeRecord);

    final gardenRecord = recordJson[QueryKey.expand][InvitationField.garden];
    final gardenCreator = await getUserByID(gardenRecord[GardenField.creator]);
    final garden = Garden.fromJson(gardenRecord, gardenCreator);

    final invitation = Invitation.fromJson(recordJson, creator, garden, invitee);

    invitationsList.add(invitation);
  }

  return invitationsList;
}

/// Returns the [InvitationType] enum that corresponds to [typeString].
InvitationType? getInvitationTypeFromString(String typeString) {
  try {
    return InvitationType.values.firstWhere(
      (a) => a.name == typeString
    );
  } on StateError {
    return null;
  }
}

/// Checks that there exists an [Invitation] with [uuid] and, if valid, creates a
/// [UserGardenRecord] for that Invitation's corresponding [Garden].
Future<void> validateInvitationUUIDAndCreateUserGardenRecord(
  String uuid, {
  required void Function(String) successCallback,
  required void Function(String) errorCallback,
  DateTime? expiryDateThreshold, // primarily for testing
}) async {
  String gardenName = "";
  String errorMessage = InvitationsText.invalidInvitationError;

  final expiryDateThresholdString =
      DateFormat(Formats.dateYMMddHHms).format(expiryDateThreshold ?? DateTime.now());

  // Get Invitation
  final resultList = await GetIt.instance<InvitationsRepository>().getList(
    expand: InvitationField.garden,
    filter: ""
      "${InvitationField.uuid} = '$uuid' "
      "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
  );

  if (resultList.items.isNotEmpty) {
    final recordJson = resultList.items.first.toJson();

    // Create UserGardenRecord
    final (_, errorsMap) =
      await GetIt.instance<UserGardenRecordsRepository>().create(
        body: {
          UserGardenRecordField.garden: recordJson[InvitationField.garden],
          UserGardenRecordField.role: AppUserGardenRole.member.name,
          UserGardenRecordField.user: GetIt.instance<AppState>().currentUser!.id,
        }
      );

    if (errorsMap.isEmpty) {
      gardenName =
        recordJson[QueryKey.expand][InvitationField.garden][GardenField.name];
    } else {
      errorMessage = InvitationsText.createUserGardenRecordError;
    }
  }

  gardenName.isEmpty ?
    errorCallback(errorMessage)
    : successCallback(gardenName);
}