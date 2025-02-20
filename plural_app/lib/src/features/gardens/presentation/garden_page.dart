import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Garden
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/utils/app_state.dart';

class GardenPage extends StatefulWidget {
  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  late Future<Function> _asksUnsubscribe;
  late Future<Function> _gardensUnsubscribe;
  late Future<Function> _usersUnsubscribe;
  late Future<Function> _userSettingsUnsubscribe;

  @override
  void initState() {
    super.initState();

    var appState = GetIt.instance<AppState>();
    var currentGarden = appState.currentGarden!;

    _asksUnsubscribe = GetIt.instance<AsksRepository>().subscribeTo(
      currentGarden.id,
      appState.notifyAllListeners
    );

    _gardensUnsubscribe = GetIt.instance<GardensRepository>().subscribeTo(
      currentGarden.id
    );

    _usersUnsubscribe = GetIt.instance<AuthRepository>().subscribeToUsers(
      currentGarden.id,
      appState.notifyAllListeners
    );

    _userSettingsUnsubscribe = GetIt.instance<AuthRepository>().subscribeToUserSettings(
      currentGarden.id,
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
              GardenFooter(),
              gapH65
            ],
          ),
        ),
      )
    );
  }
}