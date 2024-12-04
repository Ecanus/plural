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

  // Always clear before creating anew
  getIt<PocketBase>().authStore.clear();
  await getIt.reset();

  // Database
  getIt.registerLazySingleton<PocketBase>(
    () => pb
  );

  // Auth
  getIt.registerLazySingleton<AppDialogManager>(
    () => AppDialogManager()
  );

  // Gardens
  getIt.registerSingleton<GardenTimelineNotifier>(GardenTimelineNotifier());

  getIt.registerLazySingleton<GardenManager>(
    () => GardenManager(
      timelineNotifier: getIt<GardenTimelineNotifier>()
    )
  );

  // Gardens
  getIt.registerLazySingleton<GardensRepository>(
    () => GardensRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // Asks
  getIt.registerLazySingleton<AsksRepository>(
    () => AsksRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // Auth
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      pb: getIt<PocketBase>(),
    )
  );

  await getIt<AuthRepository>().setCurrentUserLatestGardenRecord();
}