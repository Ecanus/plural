import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/environments.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';
import 'package:plural_app/src/utils/service_locator.dart';


/// Returns an instance of [AppUser] corresponding to the [User] record
/// from the database with the given [userID].
Future<AppUser> getUserByID(String userID) async {
  final query = await GetIt.instance<UsersRepository>().getFirstListItem(
    filter: "${GenericField.id} = '$userID'",
  );

  return AppUser.fromJson(query.toJson());
}

/// Attempts to update the [User] record that matches the values passed
/// in the given [map] parameter.
///
/// Returns true and an empty map if updated successfully,
/// else false and a map of the errors.
Future<(bool, Map)> updateUser(Map map) async {
  try {
    await GetIt.instance<UsersRepository>().update(
      id: map[GenericField.id],
      body: {
        UserField.firstName: map[UserField.firstName],
        UserField.lastName: map[UserField.lastName],
      }
    );

    return (true, {});
  } on ClientException catch(e) {
    var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
        "updateUser() error",
        error: e,
      );

      return (false, errorsMap);
  }
}

/// Attempts to update the [UserSettings] record that matches the values passed
/// in the given [map] parameter.
///
/// Returns true and an empty map if updated successfully,
/// else false and a map of the errors.
Future<(bool, Map)> updateUserSettings(Map map) async {
  try {
    await GetIt.instance<UserSettingsRepository>().update(
      id: map[GenericField.id],
      body: {
        UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
        UserSettingsField.defaultInstructions: map[UserSettingsField.defaultInstructions],
      }
    );

    return (true, {});
  } on ClientException catch(e) {
    var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
        "updateUser() error",
        error: e,
      );

      return (false, errorsMap);
  }
}

/// Attempts to log in to the database with [usernameOrEmail]
/// and [password] parameters, and creates all necessary [GetIt] instances.
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

/// Attempts to create a new [User] record in the database with the
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

/// Attempts to send an email to [email] containing instructions
/// to reset the account password corresponding to that account.
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
/// across all Collections, then deletes the [User] record itself.
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