// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

class GardenManager {
  GardenManager({
    required this.timelineNotifier,
  });

  GardenTimelineNotifier timelineNotifier;
}