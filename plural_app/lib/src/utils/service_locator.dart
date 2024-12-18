import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

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

  // GardenTimelineNotifier
  getIt.registerSingleton<GardenTimelineNotifier>(GardenTimelineNotifier());

  // Garden Manager
  getIt.registerLazySingleton<GardenManager>(
    () => GardenManager(
      timelineNotifier: getIt<GardenTimelineNotifier>()
    )
  );

  // GardensRepository
  getIt.registerLazySingleton<GardensRepository>(
    () => GardensRepository(
      pb: getIt<PocketBase>(),
    )
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

  // Set current user's latestGardenRecord value
  await getIt<AuthRepository>().setCurrentUserLatestGardenRecord();
}

/// Resets the [GetIt] instance used in the application.
/// If [logout] is true, will also clear the database authentication tokens.
Future<void> clearGetItInstances({bool logout = false}) async {
  final getIt = GetIt.instance;

  if (logout) getIt<PocketBase>().authStore.clear();

  await getIt.reset();
}