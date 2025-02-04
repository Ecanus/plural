import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenManager {
  GardenManager({
    required this.timelineNotifier,
  });

  GardenTimelineNotifier timelineNotifier;

  /// Updates the current user's latest [UserGardenRecord] to now point to the [Garden]
  /// with the corresponding [gardenID].
  ///
  /// Reloads the GardenTimeline widget to display the most recently created
  /// [Ask]s associated with the passed [gardenID].
  Future<void> retrieveNewGarden(BuildContext context, String gardenID) async {
    var appState = GetIt.instance<AppState>();

    await GetIt.instance<AuthRepository>().updateUserGardenRecord(
      appState.currentUser!.id, gardenID);

    timelineNotifier.updateValue(gardenID);
    appState.currentGarden = await GetIt.instance<GardensRepository>()
      .getGardenByID(gardenID);


    if (context.mounted) Navigator.pop(context);
  }
}