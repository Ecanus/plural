import 'package:pocketbase/pocketbase.dart';

// Common Functions
import 'package:plural_app/src/common_functions/errors.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class TestContext {
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

  RecordModel getAskRecordModel({
    List<String> sponsors = const []
  }) {
    return RecordModel(
    id: "TESTASK1",
    created: "1995-06-13",
    collectionName: "asks",
    data: {
      AskField.boon: 15,
      AskField.creator: user.id,
      AskField.currency: "GHS",
      AskField.description: "Test description of TESTASK1",
      AskField.deadlineDate: "1995-07-24",
      AskField.instructions: "Test instructions of TESTASK1",
      AskField.sponsors: sponsors,
      AskField.targetSum: 160,
      AskField.targetMetDate: "",
      AskField.type: "monetary"
    }
  );
  }

  RecordModel getGardenRecordModel() {
    return RecordModel(
      id: garden.id,
      created: "1990-10-16",
      collectionName: Collection.gardens,
      data: {
        GardenField.creator: user.id,
        GardenField.name: garden.name,
      }
    );
  }

  RecordModel getGardenRecordRecordModel() {
    return RecordModel(
      id: userGardenRecord.id,
      created: "1999-10-08",
      collectionName: Collection.userGardenRecords,
      data: {
        UserGardenRecordField.user: user.id,
        UserGardenRecordField.garden: garden.id,
      }
    );
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

  RecordModel getUserRecordModel() {
    return RecordModel(
      id: user.id,
      created: "1992-12-23",
      collectionName: Collection.users,
      data: {
        UserField.email: user.email,
        UserField.username: user.username,
      }
    );
  }

  RecordModel getUserSettingsRecordModel() {
    return RecordModel(
      id: userSettings.id,
      created: "2001-01-03",
      collectionName: Collection.userSettings,
      data: {
        UserSettingsField.defaultCurrency: "GHS",
        UserSettingsField.defaultInstructions: "UserSettings record instructions",
        UserSettingsField.user: user.id,
      }
    );
  }
}