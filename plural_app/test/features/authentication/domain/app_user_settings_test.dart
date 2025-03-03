import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

void main() {
  group("AppUserSettings test", () {
    var user = AppUser(
      email: "test@user.com",
      id: "TESTUSER1",
      username: "testuser1",
    );

    var userSettings = AppUserSettings(
      defaultCurrency: "GHS",
      defaultInstructions: "The test default instructions",
      id: "TESTUSERSETTINGS1",
      user: user,
    );

    test("constructor", () {
      expect(userSettings.defaultCurrency == "GHS", true);
      expect(userSettings.defaultInstructions == "The test default instructions", true);
      expect(userSettings.id == "TESTUSERSETTINGS1", true);
      expect(userSettings.user == user, true);
    });

    test("toMap", () {
      var settingsToMap = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "The default instructions to map",
        id: "TESTUSERSETTINGS2",
        user: user,
      );

      var map = {
        UserSettingsField.defaultCurrency: "KRW",
        UserSettingsField.defaultInstructions: "The default instructions to map",
        GenericField.id: "TESTUSERSETTINGS2",
        UserSettingsField.user: user.id,
      };

      expect(settingsToMap.toMap(), map);
    });
  });
}