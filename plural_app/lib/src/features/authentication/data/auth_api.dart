import 'dart:developer' as developer;

import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/environments.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

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
    await pb.collection(Collection.users).authWithPassword(
      usernameOrEmail, password);

    await clearGetItInstance();
    await registerGetItInstances(pb);

    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "AuthRepository login() error",
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
  await pb.collection(Collection.asks).unsubscribe();
  await pb.collection(Collection.gardens).unsubscribe();
  await pb.collection(Collection.users).unsubscribe();
  await pb.collection(Collection.userSettings).unsubscribe();

  // Clear logged in credentials and GetIt instance
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
    await pb.collection(Collection.userSettings).create(
      body: {
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
        UserSettingsField.user: userRecord.id,
      }
    );

    // Send verification email
    await pb.collection(Collection.users).requestVerification(email);

    // Return
    return (true, {});
  } on ClientException catch(e) {
    var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
      "AuthRepository signup() error",
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
    await pb.collection(Collection.users).requestPasswordReset(email);

    // Return
    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "AuthRepository sendPasswordResetCode() error",
      error: e,
    );

    return false;
  }
}