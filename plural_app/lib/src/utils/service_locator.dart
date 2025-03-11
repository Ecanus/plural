import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

/// Populates the [GetIt] instance with the necessary singleton
/// instances used throughout the app.
Future<void> registerGetItInstances(PocketBase pb) async {
  final getIt = GetIt.instance;

  // Database
  getIt.registerLazySingleton<PocketBase>(
    () => pb
  );

  // AppDialogManager
  getIt.registerLazySingleton<AppDialogRouter>(
    () => AppDialogRouter()
  );

  // AsksRepository
  getIt.registerLazySingleton<AsksRepository>(
    () => AsksRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // AuthRepository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // GardensRepository
  getIt.registerLazySingleton<GardensRepository>(
    () => GardensRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // AppState
  getIt.registerLazySingleton<AppState>(
    () => AppState()
  );

  var userMap = pb.authStore.model.toJson();
  await setInitialAppStateValues(userMap[GenericField.id]);
}


/// Assigns values to the global [AppState] instance using the given
/// [userID].
Future<void> setInitialAppStateValues(userID) async {
  var appState = GetIt.instance<AppState>();

  // User
  var user = await GetIt.instance<AuthRepository>().getUserByID(userID);
  appState.currentUser = user;

  // User Settings
  var userSettings = await GetIt.instance<AuthRepository>().getCurrentUserSettings();
  appState.currentUserSettings = userSettings;
}

/// Resets the [GetIt] instance used in the application.
/// If [logout] is true, will also clear the database authentication tokens.
Future<void> clearGetItInstances({bool logout = false}) async {
  final getIt = GetIt.instance;

  if (logout) getIt<PocketBase>().authStore.clear();

  await getIt.reset();
}