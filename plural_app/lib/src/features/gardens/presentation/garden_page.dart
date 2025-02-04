import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Garden
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:provider/provider.dart';

class GardenPage extends StatefulWidget {
  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  late Future<Function> gardenUnsubscribe;
  late Future<Function> askUnsubscribe;

  @override
  void initState() {
    super.initState();

    var appState = GetIt.instance<AppState>();
    var currentGarden = appState.currentGarden!;

    gardenUnsubscribe = GetIt.instance<GardensRepository>().subscribeTo(
      currentGarden.id);

    askUnsubscribe = GetIt.instance<AsksRepository>().subscribeTo(
      currentGarden.id,
      appState.notifyAllListeners
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: GetIt.instance<AppState>(),
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              gapH60,
              GardenHeader(),
              gapH30,
              GardenTimeline(),
              gapH15,
              Row(
                children: [
                  GardenFooter()
                ],
              ),
              gapH15
            ],
          ),
        ),
      )
    );
  }
}