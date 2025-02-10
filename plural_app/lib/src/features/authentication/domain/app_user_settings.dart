// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class AppUserSettings {
  AppUserSettings({
    required this.id,
    required this.user,
    required this.textSize,
    required this.instructions
  });

  final String id;
  final AppUser user;

  final String instructions;
  final int textSize;

  set textSize(value) {
    textSize = value.clamp(
      UserSettingsValues.textSizeMin,
      UserSettingsValues.textSizeMax);
  }

  Map toMap() {
    return {
      GenericField.id: id,
      UserSettingsField.userID: user,
      UserSettingsField.instructions: instructions,
      UserSettingsField.textSize: textSize,
    };
  }
}