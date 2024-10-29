import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

Future<void> submitUpdate(
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    final authRepository = GetIt.instance<AuthRepository>();
    final gardenStateManager = GetIt.instance<GardenManager>();
    final appDialogManager = GetIt.instance<AppDialogManager>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    var updatedUserSettings = await authRepository.updateUserSettings(map);

    // Rebuild the Garden Timeline
    await gardenStateManager.timelineNotifier.updateValue();

    // Rebuild User Settings Dialog
    await appDialogManager.showUserSettingsDialogView(
      userSettings: updatedUserSettings);
  }
}

Future<void> submitLogIn(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var isValid = await login(
      map[LogInField.usernameOrEmail],
      map[LogInField.password]);

    if (isValid && context.mounted) {
      GoRouter.of(context).go("/");
    } else {
      // TODO: Display Error Message for the TextFormFields
    }
  }

}