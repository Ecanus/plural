import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Classes
import 'package:plural_app/src/common_classes/app_form.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";
import 'package:plural_app/src/features/authentication/domain/constants.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

/// Validates the given [formKey] to update corresponding data
/// in the [map] parameter.
Future<void> submitUpdate(
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    final authRepository = GetIt.instance<AuthRepository>();
    final appDialogManager = GetIt.instance<AppDialogManager>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    var updatedUserSettings = await authRepository.updateUserSettings(map);

    // TODO: Subscribe to changes to the UserSettings collection, and remove notifyAllListeners() call.
    // Rebuild the Garden Timeline
    GetIt.instance<AppState>().notifyAllListeners();

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
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var isValid = await login(
      appForm.getValue(fieldName: SignInField.usernameOrEmail),
      appForm.getValue(fieldName: UserField.password)
    );

    if (isValid && context.mounted) {
      // Check if current user has a latestGardenRecord
      var routeString =
        GetIt.instance<AppState>().currentUser!.latestGardenRecord == null ?
          Routes.landing : Routes.home;

      // Route to the routeString value
      GoRouter.of(context).go(routeString);
    } else {
      // Add errors to corresponding fields
      appForm.setError(
        fieldName: SignInField.usernameOrEmail,
        errorMessage: ErrorMessages.invalidEmailOrPassword
      );
      appForm.setError(
        fieldName: UserField.password,
        errorMessage: ErrorMessages.invalidEmailOrPassword
      );

      // Rebuild widget
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

/// Validates the given [formKey] to use the data in the [map] parameter
/// to create a new user.
Future<void> submitSignUp(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var (isValid, errorsMap) = await signup(
      appForm.getValue(fieldName: UserField.firstName),
      appForm.getValue(fieldName: UserField.lastName),
      appForm.getValue(fieldName: UserField.username),
      appForm.getValue(fieldName: UserField.email),
      appForm.getValue(fieldName: UserField.password),
      appForm.getValue(fieldName: UserField.passwordConfirm),
    );

    if (isValid && context.mounted) {
      // Go to log in tab
      DefaultTabController.of(context).animateTo(AuthConstants.logInTabIndex);

      // Display Success Snackbar
      var snackBar = AppSnackbars.successSnackbar(
          SnackBarMessages.sentUserVerificationEmail,
          appForm.getValue(fieldName: UserField.email)
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild widget
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

/// Validates the given [formKey] to use the data in the [map] parameter
/// to send a verification code to the corresponding user.
Future<void> submitForgotPassword(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var email = appForm.getValue(fieldName: UserField.email);
    var isValid = await sendPasswordResetCode(email);

    if (context.mounted) {
      // Close dialog
      Navigator.pop(context);

      // Display snackBar confirmation
      if (isValid) {
        var snackBar = AppSnackbars.successSnackbar(
          SnackBarMessages.sentPasswordResetEmail,
          email
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}