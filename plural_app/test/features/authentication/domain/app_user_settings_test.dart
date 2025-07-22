import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Test
import '../../../test_context.dart';

void main() {
  group("AppUserSettings", () {
    test("constructor", () {
      final tc = TestContext();
      final userSettings = AppUserSettings(
        defaultCurrency: "GHS",
        defaultInstructions: "The default instructions!!",
        gardenTimelineDisplayCount: 3,
        id: "USERSETTINGSTEST",
        user: tc.user
      );

      expect(userSettings.defaultCurrency == "GHS", true);
      expect(userSettings.defaultInstructions == "The default instructions!!", true);
      expect(userSettings.gardenTimelineDisplayCount == 3, true);
      expect(userSettings.id == "USERSETTINGSTEST", true);
      expect(userSettings.user == tc.user, true);
    });

    test("toMap", () {
      final tc = TestContext();

      var settingsToMap = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "The default instructions to map",
        gardenTimelineDisplayCount: 3,
        id: "TESTUSERSETTINGS2",
        user: tc.user,
      );

      var map = {
        UserSettingsField.defaultCurrency: "KRW",
        UserSettingsField.defaultInstructions: "The default instructions to map",
        UserSettingsField.gardenTimelineDisplayCount: 3,
        GenericField.id: "TESTUSERSETTINGS2",
        UserSettingsField.user: tc.user.id,
      };

      expect(settingsToMap.toMap(), map);
    });

    test("==", () {
      final tc = TestContext();
      final userSettings = tc.userSettings;

      final differentUser = AppUser(
        firstName: "DifferentFirst",
        id: "OTHERID",
        lastName: "DifferentLast",
        username: "otheruser"
      );

      // Identity
      expect(userSettings == userSettings, true);

      // Same ID and User
      final sameIDAndUser = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: userSettings.id,
        user: tc.user
      );

      expect(userSettings == sameIDAndUser, true);

      // Different ID and User
      final differentIDAndUser = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: "DIFFERENTID",
        user: differentUser
      );

      expect(userSettings == differentIDAndUser, false);

      // Same ID and Different User
      final sameIDAndDifferentUser = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: userSettings.id,
        user: differentUser
      );

      expect(userSettings == sameIDAndDifferentUser, false);

      // Different ID and Same User
      final differentIDAndSameUser = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: "DIFFERENTID",
        user: tc.user
      );

      expect(userSettings == differentIDAndSameUser, false);
    });
  });
}