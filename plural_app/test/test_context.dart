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

class TestContext {
  late Ask ask;
  late Garden garden;
  late AppUser user;
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

    garden = Garden(
      creator: user,
      id: "TESTGARDEN1",
      name: "Petunia"
    );

    userGardenRecord = AppUserGardenRecord(
      user: user,
      garden: garden,
      id: "TESTGARDENRECORD1",
      role: AppUserGardenRole.member,
    );

    userSettings = AppUserSettings(
      defaultCurrency: "GHS",
      defaultInstructions: "The default instructions",
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
    String? id,
    String? name,
  }) {
    return RecordModel({
      "id": id ?? garden.id,
      "created": "1990-10-16",
      "collectionName": Collection.gardens,
      GardenField.creator: creatorID ?? user.id,
      GardenField.name: name ?? garden.name,
    });
  }

  RecordModel getUserGardenRecordRecordModel({
    String? id,
    AppUserGardenRole? role,
  }) {
    return RecordModel({
      "id": id ?? userGardenRecord.id,
      "created": "1999-10-08",
      "collectionName": Collection.userGardenRecords,
      UserGardenRecordField.user: user.id,
      UserGardenRecordField.garden: garden.id,
      UserGardenRecordField.role: role?.name ?? AppUserGardenRole.member.name,
    });
  }

  RecordModel getExpandUserGardenRecordRecordModel(
    List<String> expand, {
    AppUserGardenRole role = AppUserGardenRole.member,
}) {
    Map<String, dynamic> map = {};

    if (expand.contains(UserGardenRecordField.user)) {
      map[UserGardenRecordField.user] = {
        GenericField.id: user.id,
        GenericField.created: "1992-12-23",
        UserField.firstName: user.firstName,
        UserField.lastName: user.lastName,
        UserField.username: user.username
      };
    }

    if (expand.contains(UserGardenRecordField.garden)) {
      map[UserGardenRecordField.garden] = {
        GenericField.id: garden.id,
        GenericField.created: "1993-11-11",
        GardenField.creator: user.id,
        GardenField.name: garden.name,
      };
    }

    return RecordModel.fromJson({
      GenericField.id: userGardenRecord.id,
      GenericField.created: "1999-10-08",
      UserGardenRecordField.user: user.id,
      UserGardenRecordField.garden: garden.id,
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
    String? userID,
  }) {
    return RecordModel({
      "id": userSettings.id,
      "created": "2001-01-03",
      "collectionName": Collection.userSettings,
      UserSettingsField.defaultCurrency: defaultCurrency ?? "GHS",
      UserSettingsField.defaultInstructions:
        defaultInstructions ?? "UserSettings record instructions",
      UserSettingsField.user: userID ?? user.id,
    });
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