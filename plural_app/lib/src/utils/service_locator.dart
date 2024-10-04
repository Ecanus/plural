import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

void setupGetIt() {
  final getIt = GetIt.instance;
  final pb = PocketBase("http://127.0.0.1:8090"); // TODO: Change url dynamically by env


  // Asks
  getIt.registerLazySingleton<AsksRepository>(
    () => AsksRepository(pb: pb)
  );

  // Gardens
  getIt.registerSingleton<GardenTimelineNotifier>(GardenTimelineNotifier());

  getIt.registerLazySingleton<GardenManager>(
    () => GardenManager(
      timelineNotifier: getIt<GardenTimelineNotifier>()
    ));
}