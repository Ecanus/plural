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

// Utils
import 'package:plural_app/src/utils/exceptions.dart';

class TestContext {
  late Ask ask;
  late Garden garden;
  late AppUser user;
  late AppUserGardenRecord userGardenRecord;
  late AppUserSettings userSettings;
  late ClientException clientException;

  TestContext() {
    user = AppUser(
      email: "test@user.com",
      id: "TESTUSER1",
      username: "testuser"
    );

    garden = Garden(
      creator: user,
      id: "TESTGARDEN1",
      name: "Petunia"
    );

    userGardenRecord = AppUserGardenRecord(
      id: "TESTGARDENRECORD1",
      user: user,
      garden: garden
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
        dataKey: {
          "FieldKey": {
            messageKey: "The inner map message of signup()"
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
      AskField.targetMetDate: ask.targetMetDate ?? "",
      AskField.type: "monetary"
    });
  }

  RecordModel getGardenRecordModel() {
    return RecordModel({
      "id": garden.id,
      "created": "1990-10-16",
      "collectionName": Collection.gardens,
      GardenField.creator: user.id,
      GardenField.name: garden.name,
    });
  }

  RecordModel getGardenRecordRecordModel() {
    return RecordModel({
      "id": userGardenRecord.id,
      "created": "1999-10-08",
      "collectionName": Collection.userGardenRecords,
      UserGardenRecordField.user: user.id,
      UserGardenRecordField.garden: garden.id,
    });
  }

  RecordModel getGardenRecordRecordModelFromJson(String expand) {
    Map<String, dynamic> map;

    switch (expand) {
      case UserGardenRecordField.user:
        map = {
          UserGardenRecordField.user: {
            GenericField.id: user.id,
            GenericField.created: "1992-12-23",
            UserField.email: user.email,
            UserField.username: user.username
          },
        };
      case UserGardenRecordField.garden:
        map = {
          UserGardenRecordField.garden: {
            GenericField.id: garden.id,
            GenericField.created: "1993-11-11",
            GardenField.creator: user.id,
            GardenField.name: garden.name,
          },
        };
      default:
        map = {};
    }

    return RecordModel.fromJson({
      GenericField.id: userGardenRecord.id,
      GenericField.created: "1999-10-08",
      UserGardenRecordField.user: user.id,
      UserGardenRecordField.garden: garden.id,
      "expand": map
    });
  }

  RecordModel getUserRecordModel({
    String? id,
    String? email,
    String? username,
  }) {
    return RecordModel({
      "id": id ?? user.id,
      "created": "1992-12-23",
      "collectionName": Collection.users,
      UserField.email: email ?? user.email,
      UserField.username: username ?? user.username,
    });
  }

  RecordModel getUserSettingsRecordModel() {
    return RecordModel({
      "id": userSettings.id,
      "created": "2001-01-03",
      "collectionName": Collection.userSettings,
      UserSettingsField.defaultCurrency: "GHS",
      UserSettingsField.defaultInstructions: "UserSettings record instructions",
      UserSettingsField.user: user.id,
  });
  }
}