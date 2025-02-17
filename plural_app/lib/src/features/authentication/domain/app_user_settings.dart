// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class AppUserSettings {
  AppUserSettings({
    required this.id,
    required this.user,
    required this.defaultCurrency,
    required this.defaultInstructions,
  });

  final String id;
  final AppUser user;

  final String defaultCurrency;
  final String defaultInstructions;

  Map toMap() {
    return {
      GenericField.id: id,
      UserSettingsField.userID: user,
      UserSettingsField.defaultCurrency: defaultCurrency,
      UserSettingsField.defaultInstructions: defaultInstructions
    };
  }
}