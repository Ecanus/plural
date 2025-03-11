import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Test
import '../../../test_context.dart';

void main() {
  group("AppUserSettings test", () {
    test("constructor", () {
      final tc = TestContext();
      final userSettings = tc.userSettings;

      expect(userSettings.defaultCurrency == "GHS", true);
      expect(userSettings.defaultInstructions == "The default instructions", true);
      expect(userSettings.id == "USERSETTINGS1", true);
      expect(userSettings.user == tc.user, true);
    });

    test("toMap", () {
      final tc = TestContext();

      var settingsToMap = AppUserSettings(
        defaultCurrency: "KRW",
        defaultInstructions: "The default instructions to map",
        id: "TESTUSERSETTINGS2",
        user: tc.user,
      );

      var map = {
        UserSettingsField.defaultCurrency: "KRW",
        UserSettingsField.defaultInstructions: "The default instructions to map",
        GenericField.id: "TESTUSERSETTINGS2",
        UserSettingsField.user: tc.user.id,
      };

      expect(settingsToMap.toMap(), map);
    });
  });
}