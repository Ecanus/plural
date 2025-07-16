import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: GetIt.instance<AppState>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        body: Center(
          child: Column(
            children: [
              gapH60,
              GardenHeader(isAdminPage: true,),
              gapH30,
              GardenTimeline(isAdminPage: true),
              GardenFooter(isAdminPage: true,),
              gapH35
            ],
          ),
        ),
      )
    );
  }
}