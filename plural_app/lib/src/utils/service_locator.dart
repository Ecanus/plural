import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

/// Populates the [GetIt] instance with the necessary singleton
/// instances used throughout the app.
Future<void> registerGetItInstances(PocketBase pb) async {
  final getIt = GetIt.instance;

  // Database
  getIt.registerLazySingleton<PocketBase>(
    () => pb
  );

  // AppDialogViewRouter
  getIt.registerLazySingleton<AppDialogViewRouter>(
    () => AppDialogViewRouter()
  );

  // AsksRepository
  getIt.registerLazySingleton<AsksRepository>(
    () => AsksRepository(pb: getIt<PocketBase>())
  );

  // Authentication
  getIt.registerLazySingleton<UserGardenRecordsRepository>(
    () => UserGardenRecordsRepository(pb: getIt<PocketBase>())
  );
  getIt.registerLazySingleton<UserSettingsRepository>(
    () => UserSettingsRepository(pb: getIt<PocketBase>())
  );
  getIt.registerLazySingleton<UsersRepository>(
    () => UsersRepository(pb: getIt<PocketBase>())
  );

  // GardensRepository
  getIt.registerLazySingleton<GardensRepository>(
    () => GardensRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // InvitationsRepository
  getIt.registerLazySingleton<InvitationsRepository>(
    () => InvitationsRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // AppState
  getIt.registerLazySingleton<AppState>(
    () => AppState()
  );

  var userID = pb.authStore.record!.id;
  await setInitialAppStateValues(userID);
}


/// Assigns values to the global [AppState] instance using [userID].
Future<void> setInitialAppStateValues(String userID) async {
  var appState = GetIt.instance<AppState>();

  // User
  final user = await getUserByID(userID);
  appState.currentUser = user;

  // User Settings
  final userSettings = await getCurrentUserSettings();
  appState.currentUserSettings = userSettings;
}

/// Resets the [GetIt] instance used in the application.
Future<void> clearGetItInstance() async {
  await GetIt.instance.reset();
}