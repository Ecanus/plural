import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Test
import '../../../test_factories.dart';

void main() {
  group("AppUserSettings", () {
    test("constructor", () {
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(
        defaultCurrency: "GHS",
        defaultInstructions: "The default instructions!!",
        gardenTimelineDisplayCount: 3,
        id: "USERSETTINGSTEST",
        user: user,
      );

      expect(userSettings.defaultCurrency == "GHS", true);
      expect(userSettings.defaultInstructions == "The default instructions!!", true);
      expect(userSettings.gardenTimelineDisplayCount == 3, true);
      expect(userSettings.id == "USERSETTINGSTEST", true);
      expect(userSettings.user == user, true);
    });

    test("toMap", () {
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(
        defaultCurrency: "KRW",
        defaultInstructions: "The default instructions to map",
        gardenTimelineDisplayCount: 3,
        id: "TESTUSERSETTINGS2",
        user: user,
      );

      var map = {
        UserSettingsField.defaultCurrency: "KRW",
        UserSettingsField.defaultInstructions: "The default instructions to map",
        UserSettingsField.gardenTimelineDisplayCount: 3,
        GenericField.id: "TESTUSERSETTINGS2",
        UserSettingsField.user: user.id,
      };

      expect(userSettings.toMap(), map);
    });

    test("==", () {
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      final differentUser = AppUserFactory(
        firstName: "DifferentFirst",
        id: "OTHERID",
        lastName: "DifferentLast",
        username: "otheruser"
      );

      // Identity
      expect(userSettings == userSettings, true);

      // Same ID and User
      final sameIDAndUser = AppUserSettingsFactory.uncached(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: userSettings.id,
        user: user
      );

      expect(userSettings == sameIDAndUser, true);

      // Different ID and User
      final differentIDAndUser = AppUserSettingsFactory.uncached(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: "DIFFERENTID",
        user: differentUser
      );

      expect(userSettings == differentIDAndUser, false);

      // Same ID and Different User
      final sameIDAndDifferentUser = AppUserSettingsFactory.uncached(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: userSettings.id,
        user: differentUser
      );

      expect(userSettings == sameIDAndDifferentUser, false);

      // Different ID and Same User
      final differentIDAndSameUser = AppUserSettingsFactory.uncached(
        defaultCurrency: "KRW",
        defaultInstructions: "Instructions!!",
        gardenTimelineDisplayCount: 3,
        id: "DIFFERENTID",
        user: user
      );

      expect(userSettings == differentIDAndSameUser, false);
    });
  });
}