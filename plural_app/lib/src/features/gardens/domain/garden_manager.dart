import 'package:get_it/get_it.dart';

// Gardens
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

class GardenManager {
  GardenManager({
    required this.timelineNotifier,
  }) {
    final authRepository = GetIt.instance<AuthRepository>();
    currentGarden = authRepository.currentUser!.latestGardenRecord!.garden;
  }

  Garden? currentGarden;
  GardenTimelineNotifier timelineNotifier;
}