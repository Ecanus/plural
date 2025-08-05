// Invitations
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
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