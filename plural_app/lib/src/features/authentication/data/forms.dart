import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/constants.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

/// Validates and submits form data to update an existing [UserSettings] record
/// in the database.
Future<void> submitUpdateSettings(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm userAppForm,
  AppForm userSettingsAppForm, {
  required String currentRoute,
}) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Update.
    // If in a Garden, subscribeTo() will prompt timeline refresh and currentUser reload
    final (userRecord, userErrorsMap) = await updateUser(userAppForm.fields);
    final (userSettingsRecord, userSettingsErrorsMap) =
      await updateUserSettings(userSettingsAppForm.fields);

    if (userRecord != null && userSettingsRecord != null && context.mounted) {
      final snackBar = AppSnackBars.getSnackBar(
        SnackBarText.updateUserSettingsSuccess,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Add errors to corresponding fields
      userAppForm.setErrors(errorsMap: userErrorsMap);
      userSettingsAppForm.setErrors(errorsMap: userSettingsErrorsMap);
    }

    // Determine next steps using currentRoute
    switch(currentRoute) {
      case Routes.garden:
        // Reload Dialog (and reacquire user settings)
        GetIt.instance<AppDialogViewRouter>().routeToUserSettingsView();
      case Routes.landing:
        // Force reload value of currentUser
        // (because no Garden-specific subscriptions are set in the landing page)
        GetIt.instance<AppState>().currentUser = await getUserByID(
          userAppForm.getValue(fieldName: GenericField.id)
        );
      default:
        return;
    }
  }
}

/// Validates and submits form data to update an existing [UserGardenRecord] record
/// in the database.
Future<void> submitUpdateUserGardenRecord(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    SnackBar snackBar;

    // Save form
    formKey.currentState!.save();

    // Update
    final (userGardenRecord, errorsMap) = await updateUserGardenRole(
      context, appForm.fields);

    // Handle success
    if (userGardenRecord != null && context.mounted) {
      snackBar = AppSnackBars.getSnackBar(
        SnackBarText.updateUserGardenRoleSuccess,
        snackbarType: SnackbarType.success
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Handle errors
    if (errorsMap != null) {
      appForm.setErrors(errorsMap: errorsMap);
      appForm.getValue(fieldName: AppFormFields.rebuild, isAux: true)();
      return;
    }
  }
}

/// Validates and submits form data to log in a user to the application.
Future<void> submitLogIn(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm, {
  PocketBase? database, // primarily for testing
}) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Login
    final isValid = await login(
      appForm.getValue(fieldName: SignInField.usernameOrEmail),
      appForm.getValue(fieldName: UserField.password),
      database: database
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
      appForm.getValue(
        fieldName: AppFormFields.rebuild,
        isAux: true)();
    }
  }
}

/// Validates and submits form data to create a new [User] record in the database.
Future<void> submitSignUp(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm, {
  PocketBase? database,
}) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Sign up
    final (isValid, errorsMap) = await signup(appForm.fields, database: database);

    if (isValid && context.mounted) {
      // Go to log in tab
      appForm.getValue(
        fieldName: AppFormFields.tabController,
        isAux: true)
      .animateTo(AuthConstants.logInTabIndex);

      final snackBar = AppSnackBars.getSnackBar(
        SnackBarText.sentUserVerificationEmail,
        boldMessage: appForm.getValue(fieldName: UserField.email),
        duration: AppDurations.s9,
        snackbarType: SnackbarType.success
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild widget
      appForm.getValue(
        fieldName: AppFormFields.rebuild,
        isAux: true)();
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
  PocketBase? database
}) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    final email = appForm.getValue(fieldName: UserField.email);
    final isValid = await sendPasswordResetCode(email, database: database);

    if (context.mounted) {
      // Close dialog
      Navigator.pop(context);

      if (isValid) {
        final snackBar = AppSnackBars.getSnackBar(
          SnackBarText.sentPasswordResetEmail,
          boldMessage: email,
          duration: AppDurations.s9,
          snackbarType: SnackbarType.success
        );

        // Display Success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}