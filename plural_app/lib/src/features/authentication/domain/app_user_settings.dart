// Constants
import 'package:plural_app/src/constants/values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class AppUserSettings {
  AppUserSettings({
    required this.id,
    required this.user,
    required this.textSize,
  });

  final String id;
  final AppUser user;

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
      UserSettingsField.textSize: textSize,
    };
  }
}