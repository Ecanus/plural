import 'package:plural_app/src/utils/exceptions.dart' as exceptions;

import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

class TestContext {
  late Ask ask;
  late Garden garden;
  late Invitation openInvitation;
  late Invitation privateInvitation;
  late AppUser user;
  late AppUser otherUser;
  late AppUserGardenRecord userGardenRecord;
  late AppUserSettings userSettings;
  late ClientException clientException;

  TestContext() {
    user = AppUser(
      firstName: "MyFirstName",
      id: "TESTUSER1",
      lastName: "MyLastName",
      username: "testuser"
    );

    otherUser = AppUser(
      firstName: "otherUserFirstName",
      id: "TESTOTHERUSER1",
      lastName: "otherUserLastName",
      username: "otherUser"
    );

    garden = Garden(
      creator: user,
      doDocument: "Test Do Document in TestContext",
      id: "TESTGARDEN1",
      name: "Petunia"
    );

    openInvitation = Invitation(
      creator: user,
      createdDate: DateTime(2025, 8, 15),
      expiryDate: DateTime(2050, 8, 15),
      garden: garden,
      id: "TESTINVITATIONOPEN",
      invitee: null,
      type: InvitationType.open,
      uuid: "UUUU-II-D-DDDDD",
    );

    privateInvitation = Invitation(
      creator: user,
      createdDate: DateTime(2025, 8, 15),
      expiryDate: DateTime(2050, 8, 15),
      garden: garden,
      id: "TESTINVITATIONPRIVATE",
      invitee: otherUser,
      type: InvitationType.private,
      uuid: null,
    );

    userGardenRecord = AppUserGardenRecord(
      garden: garden,
      hasReadDoDocument: true,
      id: "TESTGARDENRECORD1",
      role: AppUserGardenRole.member,
      user: user,
    );

    userSettings = AppUserSettings(
      defaultCurrency: "GHS",
      defaultInstructions: "The default instructions",
      gardenTimelineDisplayCount: 3,
      id: "USERSETTINGS1",
      user: user
    );

    ask = Ask(
      id: "TESTASK1",
      boon: 15,
      creator: user,
      creationDate: DateTime.parse("1995-06-13"),
      currency: "GHS",
      description: "Test description of TESTASK1",
      deadlineDate: DateTime.parse("1995-07-24"),
      instructions: "Test instructions of TESTASK1",
      targetMetDate: null,
      targetSum: 160,
      type: AskType.monetary,
    );

    clientException = ClientException(
      originalError: "Original error message",
      response: {
        exceptions.dataKey: {
          "FieldKey": {
            exceptions.messageKey: "The inner map message of signup()"
          }
        }
      },
    );
  }

  Ask getNewAsk({
    required String id,
    int boon = 5,
    DateTime? creationDate,
    String currency = "GHS",
    String? description,
    DateTime? deadlineDate,
    String? instructions,
    DateTime? targetMetDate,
    int targetSum = 100
  }) {
    return Ask(
      id: id,
      boon: boon,
      creator: user,
      creationDate: creationDate ?? DateTime.parse("1995-06-13"),
      currency: "GHS",
      description: description ?? "Test description of $id",
      deadlineDate: deadlineDate ?? DateTime.parse("1995-07-24"),
      instructions: instructions ?? "Test instructions of $id",
      targetMetDate: targetMetDate,
      targetSum: targetSum,
      type: AskType.monetary,
    );
  }

  RecordModel getAskRecordModel({
    String? id,
    int? boon,
    DateTime? creationDate,
    String? creatorID,
    String? currency,
    DateTime? deadlineDate,
    String? description,
    String? instructions,
    DateTime? targetMetDate,
    int? targetSum,
    List<String> sponsors = const []
  }) {
    return RecordModel({
      "id": id ?? ask.id,
      "created": DateFormat(Formats.dateYMMdd).format(creationDate ?? ask.creationDate),
      "collectionName": "asks",
      AskField.boon: boon ?? ask.boon,
      AskField.creator: creatorID ?? ask.creator.id,
      AskField.currency: currency ?? ask.currency,
      AskField.deadlineDate: DateFormat(Formats.dateYMMdd).format(
        deadlineDate ?? ask.deadlineDate),
      AskField.description: description ?? ask.description,
      AskField.instructions: instructions ?? ask.instructions,
      AskField.sponsors: sponsors,
      AskField.targetSum: targetSum ?? ask.targetSum,
      AskField.targetMetDate: targetMetDate == null ? "" :
        DateFormat(Formats.dateYMMdd).format(targetMetDate),
      AskField.type: "monetary"
    });
  }

  RecordModel getGardenRecordModel({
    String? creatorID,
    String? doDocument,
    String? id,
    String? name,
  }) {
    return RecordModel({
      "id": id ?? garden.id,
      "created": "1990-10-16",
      "collectionName": Collection.gardens,
      GardenField.creator: creatorID ?? user.id,
      GardenField.doDocument: doDocument ?? "Do Document",
      GardenField.name: name ?? garden.name,
    });
  }

  RecordModel getOpenInvitationRecordModel({
    String? id,
    String? creatorID,
    String? expiryDate,
    String? gardenID,
    List<String> expand = const [],
  }) {
    Map<String, dynamic> map = {};

    addExpandFields(expand, map);

    return RecordModel({
      "id": id ?? openInvitation.id,
      "created": DateFormat(Formats.dateYMMdd).format(openInvitation.createdDate),
      "collectionName": Collection.invitations,
      InvitationField.creator: creatorID ?? user.id,
      InvitationField.expiryDate: expiryDate ??
        DateFormat(Formats.dateYMMdd).format(openInvitation.expiryDate),
      InvitationField.garden: gardenID ?? garden.id,
      InvitationField.type: InvitationType.open.name,
      InvitationField.uuid: "UUUU-II-D-DDDDD",
      "expand": map,
    });
  }

  RecordModel getPrivateInvitationRecordModel({
    String? id,
    String? creatorID,
    String? expiryDate,
    String? gardenID,
    String? otherUserID,
    List<String> expand = const [],
  }) {
    Map<String, dynamic> map = {};

    addExpandFields(expand, map);

    return RecordModel({
      "id": id ?? privateInvitation.id,
      "created": DateFormat(Formats.dateYMMdd).format(privateInvitation.createdDate),
      "collectionName": Collection.invitations,
      InvitationField.creator: creatorID ?? user.id,
      InvitationField.expiryDate: expiryDate ??
        DateFormat(Formats.dateYMMdd).format(privateInvitation.expiryDate),
      InvitationField.garden: gardenID ?? garden.id,
      InvitationField.type: InvitationType.private.name,
      InvitationField.invitee: otherUserID ?? otherUser.id,
      "expand": map,
    });
  }


  RecordModel getUserGardenRecordRecordModel({
    String? recordID,
    AppUserGardenRole role = AppUserGardenRole.member,
    List<String> expand = const []
}) {
    Map<String, dynamic> map = {};

    addExpandFields(expand, map);

    return RecordModel.fromJson({
      GenericField.id: recordID ?? userGardenRecord.id,
      GenericField.created: "1999-10-08",
      UserGardenRecordField.user: user.id,
      UserGardenRecordField.garden: garden.id,
      UserGardenRecordField.hasReadDoDocument: true,
      UserGardenRecordField.role: role.name,
      "expand": map
    });
  }

  RecordModel getUserRecordModel({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
  }) {
    return RecordModel({
      "id": id ?? user.id,
      "created": "1992-12-23",
      "collectionName": Collection.users,
      UserField.firstName: firstName ?? user.firstName,
      UserField.lastName: lastName ?? user.lastName,
      UserField.username: username ?? user.username,
    });
  }

  RecordModel getUserSettingsRecordModel({
    String? defaultCurrency,
    String? defaultInstructions,
    int? gardenTimelineDisplayCount,
    String? userID,
  }) {
    return RecordModel({
      "id": userSettings.id,
      "created": "2001-01-03",
      "collectionName": Collection.userSettings,
      UserSettingsField.defaultCurrency: defaultCurrency ?? "GHS",
      UserSettingsField.defaultInstructions:
        defaultInstructions ?? "UserSettings record instructions",
      UserSettingsField.gardenTimelineDisplayCount:
        gardenTimelineDisplayCount ?? userSettings.gardenTimelineDisplayCount,
      UserSettingsField.user: userID ?? user.id,
    });
  }

  void addExpandFields(List<String> expandFields, Map<String, dynamic> map) {
    if (expandFields.contains(UserGardenRecordField.user)) {
      map[UserGardenRecordField.user] = {
        GenericField.id: user.id,
        GenericField.created: "1992-12-23",
        UserField.firstName: user.firstName,
        UserField.lastName: user.lastName,
        UserField.username: user.username
      };
    }

    if (
        expandFields.contains(UserGardenRecordField.garden) ||
        expandFields.contains(InvitationField.garden)
      ) {
      map[UserGardenRecordField.garden] = {
        GenericField.id: garden.id,
        GenericField.created: "1993-11-11",
        GardenField.creator: user.id,
        GardenField.doDocument: "Expaned Do Document",
        GardenField.name: garden.name,
      };
    }

    if (expandFields.contains(InvitationField.creator)) {
      map[InvitationField.creator] = {
        GenericField.id: user.id,
        GenericField.created: "1992-12-23",
        UserField.firstName: user.firstName,
        UserField.lastName: user.lastName,
        UserField.username: user.username
      };
    }

    if (expandFields.contains(InvitationField.invitee)) {
      map[InvitationField.invitee] = {
        GenericField.id: otherUser.id,
        GenericField.created: "1992-12-23",
        UserField.firstName: otherUser.firstName,
        UserField.lastName: otherUser.lastName,
        UserField.username: otherUser.username
      };
    }
  }

  ClientException getClientException({
    String originalError = "Original error message",
    String fieldKey = "FieldKey",
    String message = "The inner map message of signup()"
  }) {
    return ClientException(
      originalError: originalError,
      response: {
        exceptions.dataKey: {
          fieldKey: {
            exceptions.messageKey: message
          }
        }
      },
    );
  }
}