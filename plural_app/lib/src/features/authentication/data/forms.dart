import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";
import "package:plural_app/src/features/authentication/domain/constants.dart";

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:pocketbase/pocketbase.dart';

/// Validates and submits form data to update an existing [UserSettings] record
/// in the database.
Future<void> submitUpdateSettings(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
  String currentRoute,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Update DB (should also rebuild Garden Timeline via SubscribeTo)
    var (isValid, errorsMap) =
      await GetIt.instance<AuthRepository>().updateUserSettings(appForm.fields);

    if (isValid && context.mounted) {
      var snackBar = AppSnackbars.getSuccessSnackbar(
        SnackbarText.updateUserSettingsSuccess,
        showCloseIcon: false
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      switch(currentRoute) {
        case Routes.home:
          // Reload Dialog (and reacquire user settings)
          GetIt.instance<AppDialogRouter>().routeToUserSettingsDialogView();
        default:
          return;
      }
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      switch(currentRoute) {
        case Routes.home:
          // Reload Dialog (and reacquire user settings)
          GetIt.instance<AppDialogRouter>().routeToUserSettingsDialogView();
        default:
          return;
      }
    }
  }
}

/// Validates and submits form data to log in a user to the application.
Future<void> submitLogIn(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Get database
    // TODO: Change url dynamically by env
    PocketBase pb;
    try {
      pb = GetIt.instance<PocketBase>(); // primarily for testing
    } on StateError catch(_) {
      pb = PocketBase("http://127.0.0.1:8090");
    }

    // Login
    var isValid = await login(
      appForm.getValue(fieldName: SignInField.usernameOrEmail),
      appForm.getValue(fieldName: UserField.password),
      pb,
    );

    if (isValid && context.mounted) {
      // Route to Landing Page
      GoRouter.of(context).go(Routes.landing);
    } else {
      // Add errors to corresponding fields
      appForm.setError(
        fieldName: SignInField.usernameOrEmail,
        errorMessage: AppFormText.invalidEmailOrPassword
      );
      appForm.setError(
        fieldName: UserField.password,
        errorMessage: AppFormText.invalidEmailOrPassword
      );

      // Rebuild widget
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

/// Validates and submits form data to create a new [User] record in the database.
Future<void> submitSignUp(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm, {
  // primarily for testing
  PocketBase? database,
}) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Signup
    var (isValid, errorsMap) = await signup(
      appForm.getValue(fieldName: UserField.firstName),
      appForm.getValue(fieldName: UserField.lastName),
      appForm.getValue(fieldName: UserField.username),
      appForm.getValue(fieldName: UserField.email),
      appForm.getValue(fieldName: UserField.password),
      appForm.getValue(fieldName: UserField.passwordConfirm),
      database: database,
    );

    if (isValid && context.mounted) {
      // Go to log in tab
      appForm.getValue(fieldName: AppFormFields.tabController).animateTo(
        AuthConstants.logInTabIndex);

      var snackBar = AppSnackbars.getSuccessSnackbar(
        SnackbarText.sentUserVerificationEmail,
        boldMessage: appForm.getValue(fieldName: UserField.email),
        duration: AppDurations.s9,
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild widget
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

/// Validates and submits form data to send a password reset code
/// to the corresponding user.
Future<void> submitForgotPassword(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm, {
  // primarily for testing
  PocketBase? database,
}) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    var email = appForm.getValue(fieldName: UserField.email);
    var isValid = await sendPasswordResetCode(email, database: database);

    if (context.mounted) {
      // Close dialog
      Navigator.pop(context);

      if (isValid) {
        var snackBar = AppSnackbars.getSuccessSnackbar(
          SnackbarText.sentPasswordResetEmail,
          boldMessage: email,
          duration: AppDurations.s9
        );

        // Display Success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}