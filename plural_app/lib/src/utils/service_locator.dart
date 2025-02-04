import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

// Utils
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
  getIt.registerLazySingleton<AppDialogManager>(
    () => AppDialogManager()
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

  // ------------
  // GardenTimelineNotifier
  getIt.registerSingleton<GardenTimelineNotifier>(GardenTimelineNotifier());

  // Garden Manager
  getIt.registerLazySingleton<GardenManager>(
    () => GardenManager(
      timelineNotifier: getIt<GardenTimelineNotifier>()
    )
  );
  // ------------

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
  var user = await GetIt.instance<AuthRepository>().getUserByID(userID);

  // User
  appState.currentUser = user;

  var latestGardenRecord = await GetIt.instance<AuthRepository>()
      .getUserGardenRecordByUserID(userID: user.id);

  if (latestGardenRecord != null) {
    // Latest Garden Record
    appState.currentUserLatestGardenRecord = latestGardenRecord;

    // Garden
    appState.currentGarden = latestGardenRecord.garden;
  }
}

/// Resets the [GetIt] instance used in the application.
/// If [logout] is true, will also clear the database authentication tokens.
Future<void> clearGetItInstances({bool logout = false}) async {
  final getIt = GetIt.instance;

  if (logout) getIt<PocketBase>().authStore.clear();

  await getIt.reset();
}