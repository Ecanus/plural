import 'package:intl/intl.dart';
import 'package:test/test.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/currencies.dart';
import 'package:plural_app/src/constants/formats.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

void main() {
  group("Form validators test", () {
    test("validateCheckboxFormField", () {
      expect(validateCheckboxFormField(null), AppFormText.invalidValue);

      expect(validateCheckboxFormField(true), null);
      expect(validateCheckboxFormField(false), null);
    });

    test("validateConfirmNewPassword", () {
      expect(validateConfirmNewPassword(null, "valB"), AppFormText.invalidValue);
      expect(validateConfirmNewPassword("", "valB"), AppFormText.invalidValue);

      expect(validateConfirmNewPassword("valA", "valB"), SignInPageText.passwordMismatch);

      expect(validateConfirmNewPassword("valA", "valA"), null);
    });

    test("validateCurrency", () {
      expect(validateCurrency(null), AppFormText.invalidValue);
      expect(validateCurrency(""), AppFormText.invalidValue);
      expect(validateCurrency("???"), AppFormText.invalidValue);

      var currency = Currencies.all.keys.first;
      expect(validateCurrency(currency), null);
    });

    test("validateDatePickerFormField", () {
      expect(validateDatePickerFormField(null), AppFormText.invalidValue);
      expect(validateDatePickerFormField(""), AppFormText.invalidValue);
      expect(validateDatePickerFormField("not a date"), AppFormText.invalidValue);

      var date = DateFormat(Formats.dateYMMdd).format(DateTime.now());
      expect(validateDatePickerFormField(date), null);
    });

    test("validateDigitsOnly", () {
      expect(validateDigitsOnly(null), AppFormText.invalidValue);
      expect(validateDigitsOnly(""), AppFormText.invalidValue);
      expect(validateDigitsOnly("with text"), AppFormText.invalidValue);

      expect(validateDigitsOnly("9999"), null);
    });

    test("validateEmail", () {
      expect(validateEmail(null), AppFormText.invalidValue);
      expect(validateEmail(""), AppFormText.invalidValue);
      expect(validateEmail("not an email"), AppFormText.invalidValue);

      var invalidEmails = [
        "test@user",
        "test.com@user",
        "test@user..com",
        ".test@user.com",
        "test.@user.com",
        "test.user.com",
        "@user.com",
      ];

      for (var value in invalidEmails) {
        expect(validateEmail(value), AppFormText.invalidValue);
      }

      var validEmail = "test@user.com";
      expect(validateEmail(validEmail), null);
    });

    test("validateNewPassword", () {
      expect(validateNewPassword(null), AppFormText.invalidValue);
      expect(validateNewPassword(""), AppFormText.invalidValue);

      var g = "g" * 100;
      var invalidPasswords = [
        "NOLOWERCASE95!",
        "noNumber!",
        "noSpecialCharacter95",
        "nouppercase95!",
        "2shorT!",
        "2lon{$g}!",
      ];

      for (var value in invalidPasswords) {
        expect(validateNewPassword(value), AppFormText.invalidPassword);
      }

      var validPassword = "periWinkle44?";
      expect(validateNewPassword(validPassword), null);
    });

    test("validateText", () {
      expect(validateText(null), AppFormText.invalidValue);
      expect(validateText(""), AppFormText.invalidValue);

      expect(validateText("with text"), null);
      expect(validateText("with text and numbers 9999"), null);
      expect(validateText("9999"), null);
    });

    test("validateUserGardenRole", () {
      expect(validateUserGardenRole(null), AppFormText.invalidValue);
      expect(validateUserGardenRole(""), AppFormText.invalidValue);

      expect(validateUserGardenRole("badRole"), AppFormText.invalidValue);

      expect(validateUserGardenRole(AppUserGardenRole.owner.name), null);
      expect(validateUserGardenRole(AppUserGardenRole.administrator.name), null);
      expect(validateUserGardenRole(AppUserGardenRole.member.name), null);
    });

    test("validateUsernameOrEmail", () {
      expect(validateUsernameOrEmail(null), AppFormText.invalidValue);
      expect(validateUsernameOrEmail(""), AppFormText.invalidValue);

      expect(validateUsernameOrEmail("testuser"), null);
      expect(validateUsernameOrEmail("test@user.com"), null);
    });

    test("checkHasLowercase", () {
      expect(checkHasLowercase(null), false);
      expect(checkHasLowercase(""), false);

      expect(checkHasLowercase("ALLUPPERCASE"), false);

      expect(checkHasLowercase("alllowercase"), true);
    });

    test("checkHasNumber", () {
      expect(checkHasNumber(null), false);
      expect(checkHasNumber(""), false);

      expect(checkHasNumber("nonumber"), false);

      expect(checkHasNumber("123456"), true);
    });

    test("checkHasSpecialCharacter", () {
      expect(checkHasSpecialCharacter(null), false);
      expect(checkHasSpecialCharacter(""), false);

      expect(checkHasSpecialCharacter("nospecialcharacters"), false);

      expect(checkHasSpecialCharacter("!yes"), true);
    });

    test("checkHasUppercase", () {
      expect(checkHasUppercase(null), false);
      expect(checkHasUppercase(""), false);

      expect(checkHasUppercase("onlylowercase"), false);

      expect(checkHasUppercase("whyHELLOthere"), true);
    });

    test("checkPasswordsMatch", () {
      expect(checkPasswordsMatch(null, null), false);
      expect(checkPasswordsMatch(null, ""), false);
      expect(checkPasswordsMatch("", null), false);
      expect(checkPasswordsMatch("", ""), false);

      expect(checkPasswordsMatch("valA", ""), false);
      expect(checkPasswordsMatch("valA", null), false);
      expect(checkPasswordsMatch("", "valB"), false);
      expect(checkPasswordsMatch(null, "valB"), false);

      expect(checkPasswordsMatch("valA", "valB"), false);

      expect(checkPasswordsMatch("valA", "valA"), true);
    });

    test("checkPasswordLength", () {
      expect(checkPasswordLength(null), false);
      expect(checkPasswordLength(""), false);

      expect(checkPasswordLength("toolong" * 10), false);
      expect(checkPasswordLength("2short"), false);

      expect(checkPasswordLength("33justRight!"), true);
    });
  });
}