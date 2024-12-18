import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
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

  /// Updates the current user's latest [UserGardenRecord] to now point to [garden].
  ///
  /// Reloads the GardenTimeline widget to display the most recently created
  /// [Ask]s in the passed [garden].
  Future<void> goToGarden(BuildContext context, Garden garden) async {
    final authRepository = GetIt.instance<AuthRepository>();
    final user = authRepository.currentUser!;

    Navigator.pop(context);

    updateCurrentGarden(garden);
    await authRepository.updateUserGardenRecord(user, currentGarden!);

    timelineNotifier.updateValue();
  }

  void updateCurrentGarden(Garden garden) {
    currentGarden = garden;
  }
}