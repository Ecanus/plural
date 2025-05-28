import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/environments.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';
import 'package:plural_app/src/utils/service_locator.dart';

/// Attempts to log into the database with the given [usernameOrEmail]
/// and [password] parameters and create all necessary [GetIt] instances.
///
/// Returns true if log in is successful, else false.
Future<bool> login(
  String usernameOrEmail,
  String password,
  PocketBase pb
) async {
  try {
    // TODO: Move pb.collection call into a method in AuthRepository
    await pb.collection(Collection.users).authWithPassword(
      usernameOrEmail, password);

    await clearGetItInstance();
    await registerGetItInstances(pb);

    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "auth_api.login() error",
      error: e,
    );
    return false;
  }
}

/// Logs out of the database and clears all [GetIt] instances.
Future<void> logout(
  context, {
  // primarily for testing
  GoRouter? goRouter
  }) async {
  final pb = GetIt.instance<PocketBase>();

  // Clear all database subscriptions
  // TODO: Move pb.collection call into a method in AuthRepository
  await pb.collection(Collection.asks).unsubscribe();
  await pb.collection(Collection.gardens).unsubscribe();
  await pb.collection(Collection.users).unsubscribe();
  await pb.collection(Collection.userSettings).unsubscribe();

  // Clear logged in credentials and GetIt instance
  // TODO: Move pb.authStore call into a method in AuthRepository
  pb.authStore.clear();
  clearGetItInstance();

  if (context.mounted) {
    var router = goRouter ?? GoRouter.of(context);
    router.go(Routes.signIn);
  }
}

/// Attempts to create a new [User] record in the database with the given
/// [firstName], [lastName], [username], [email], and [password] parameters.
///
/// Returns (true, {}) if sign up is successful, else (false, errorsMap)
Future<(bool, Map)> signup(
  String firstName,
  String lastName,
  String username,
  String email,
  String password,
  String passwordConfirm, {
  // primarily for testing
  PocketBase? database
}) async {
  var pb = database ?? PocketBase(Environments.pocketbaseUrl);

  try {
    // Create User
    // TODO: Move pb.collection call into a method in AuthRepository
    final userRecord = await pb.collection(Collection.users).create(
      body: {
        UserField.email: email,
        UserField.firstName: firstName,
        UserField.lastName: lastName,
        UserField.password: password,
        UserField.passwordConfirm: passwordConfirm,
        UserField.username: username,
        UserField.emailVisibility: false,
      }
    );

    // Create UserSettings
    // TODO: Move pb.collection call into a method in AuthRepository
    await pb.collection(Collection.userSettings).create(
      body: {
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
        UserSettingsField.user: userRecord.id,
      }
    );

    // Send verification email
    // TODO: Move pb.collection call into a method in AuthRepository
    await pb.collection(Collection.users).requestVerification(email);

    // Return
    return (true, {});
  } on ClientException catch(e) {
    var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
      "auth_api.signup() error",
      error: e,
    );

      return (false, errorsMap);
  }
}

/// Attempts to send an email to the given [email] containing instructions
/// to reset the account password corresponding to [email].
///
/// Returns true if the email is successfully sent, else false.
Future<bool> sendPasswordResetCode(
  String email, {
  // primarily for testing
  PocketBase? database,
}) async {
  var pb = database ?? PocketBase(Environments.pocketbaseUrl);

  try {
    // Send password reset email
    // TODO: Move pb.collection call into a method in AuthRepository
    await pb.collection(Collection.users).requestPasswordReset(email);

    // Return
    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "auth_api.sendPasswordResetCode() error",
      error: e,
    );

    return false;
  }
}

/// Attempts to delete a [User] record, by first deleting all associated records
/// across all Collections, and then the [User] record itself.
///
/// Returns true if all deletions are successful. Else returns false.
Future<bool> deleteCurrentUserAccount({BuildContext? context}) async {
  try {
    // Delete Asks
    await GetIt.instance<AsksRepository>().deleteCurrentUserAsks();

    // Delete UserGardenRecords
    await GetIt.instance<AuthRepository>().deleteCurrentUserGardenRecords();

    // Delete UserSettings
    await GetIt.instance<AuthRepository>().deleteCurrentUserSettings();

    // Delete User
    await GetIt.instance<AuthRepository>().deleteCurrentUser();

    if (context != null && context.mounted) {
      // Route to Sign in Page
      GoRouter.of(context).go(Routes.signIn);

      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.deletedUserAccount,
        duration: AppDurations.s9,
        snackbarType: SnackbarType.success
      );

      // Display success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "auth_api.deleteCurrentUserAccount() error",
      error: e,
    );

    if (context != null && context.mounted) {
      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.deletedUserAccountFailed,
        duration: AppDurations.s9,
        snackbarType: SnackbarType.error
      );

      // Display error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }
}