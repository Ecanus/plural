// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class AppUserSettings {
  AppUserSettings({
    required this.defaultCurrency,
    required this.defaultInstructions,
    required this.id,
    required this.user,
  });

  final String defaultCurrency;
  final String defaultInstructions;
  final String id;
  final AppUser user;

  AppUserSettings.fromJson(Map<String, dynamic> json, AppUser settingsUser) :
    defaultCurrency = json[UserSettingsField.defaultCurrency],
    defaultInstructions = json[UserSettingsField.defaultInstructions],
    id = json[GenericField.id],
    user = settingsUser;

  Map<String, dynamic> toMap() {
    return {
      UserSettingsField.defaultCurrency: defaultCurrency,
      UserSettingsField.defaultInstructions: defaultInstructions,
      GenericField.id: id,
      UserSettingsField.user: user.id,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUserSettings && other.id == id && other.user == user;
  }

  @override
  int get hashCode => id.hashCode;
}