// Invitations
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

/// An action. Attemps to create a new [Invitation] record with the values passed in
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

      final invitationsBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.invitee}"
        ".${UserField.username}";

      final resultList = await GetIt.instance<UsersRepository>().getList(
        filter: ""
          "${UserField.username} = '$username' && " // username matches
          "$userGardenRecordsBackRelation != '$gardenID' && " // not a member of this Garden
          "$invitationsBackRelation != '$username'" // not already invited to this Garden
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

/// An action. Updates the [Invitation] record with the given [invitationID]
/// to have an expiryDate of DateTime.now().
Future<void> expireInvitation(
  BuildContext context,
  String invitationID, {
  DateTime? expirationDate, // primarily for testing
}) async {
  try {
    // Check permissions
    await GetIt.instance<AppState>().verify(
      [AppUserGardenPermission.expireInvitations]
    );

    // Update
    expirationDate = expirationDate ?? DateTime.now();
    await GetIt.instance<InvitationsRepository>().update(
      id: invitationID,
      body: {
        InvitationField.expiryDate: DateFormat(Formats.dateYMMdd).format(expirationDate)
      },
    );

    if (context.mounted) {
      final snackBar = AppSnackBars.getSnackBar(
        SnackBarText.askSponsored,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Route to refresh
      GetIt.instance<AppDialogViewRouter>().routeToAdminListedInvitationsView(context);
    }

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
  }
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