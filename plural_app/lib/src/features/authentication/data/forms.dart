import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/environments.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/constants.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
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

    // If in a Garden, subscribeTo() will prompt timeline refresh and currentUser reload
    var (isUserValid, userErrorsMap) = await updateUser(userAppForm.fields);
    var (isUserSettingsValid, userSettingsErrorsMap) =
      await updateUserSettings(userSettingsAppForm.fields);

    if (isUserValid && isUserSettingsValid && context.mounted) {
      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.updateUserSettingsSuccess,
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
        GetIt.instance<AppDialogRouter>().routeToUserSettingsDialogView();
      case Routes.landing:
        // Force reload value of currentUser
        // (because no garden-specific subscriptions are set in the landing page)
        GetIt.instance<AppState>().currentUser = await getUserByID(
          userAppForm.getValue(fieldName: GenericField.id)
        );
      default:
        return;
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
    PocketBase pb;
    try {
      pb = GetIt.instance<PocketBase>(); // primarily for testing
    } on StateError catch(_) {
      pb = PocketBase(Environments.pocketbaseUrl);
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

      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.sentUserVerificationEmail,
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
        var snackBar = AppSnackbars.getSnackbar(
          SnackbarText.sentPasswordResetEmail,
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