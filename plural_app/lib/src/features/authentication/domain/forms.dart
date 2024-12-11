import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:plural_app/src/common_methods/snackbars.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

/// Validates the given [formKey] to update corresponding data
/// in the [map] parameter.
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

/// Validates the given [formKey] to use the data in the [map] parameter
/// to log in the corresponding user.
Future<void> submitLogIn(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var isValid = await login(
      map[SignInField.usernameOrEmail],
      map[SignInField.password]);

    if (isValid && context.mounted) {
      // Log In Successful
      GoRouter.of(context).go(Routes.home);
    } else {
      // Log In Failed
      map[ModelMapKeys.errorTextKey] = ErrorStrings.invalidEmailOrPassword;
      map[ModelMapKeys.rebuildKey]();
    }
  }
}

/// Validates the given [formKey] to use the data in the [map] parameter
/// to create a new user.
Future<void> submitSignUp(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var isValid = await signup(
      map[UserField.firstName],
      map[UserField.lastName],
      map[UserField.username],
      map[UserField.email],
      map[SignInField.password]);

    if (isValid && context.mounted) {
      // Sign Up Successful
      // Go to Log In Tab
      // DefaultTabController.of(context).animateTo(1);
      // Display Success Snackbar
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Sign Up Failed
      map[ModelMapKeys.errorTextKey] = "Unimplemented Error Message";
      map[ModelMapKeys.rebuildKey]();
    }
  }
}

/// Validates the given [formKey] to use the data in the [map] parameter
/// to send a verification code to the corresponding user.
Future<void> submitForgotPassword(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var email = map[UserField.email];
    var isValid = await sendPasswordResetCode(email);

    if (context.mounted) {
      Navigator.pop(context);

      // Display SnackBar confirmation
      if (isValid) {
        showSuccessSnackBar(
          context,
          SnackBarStrings.sentPasswordResetEmail,
          email);
      }
    }
  }
}