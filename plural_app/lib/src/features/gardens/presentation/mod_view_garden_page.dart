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

class ModViewGardenPage extends StatefulWidget {
  @override
  State<ModViewGardenPage> createState() => _ModViewGardenPageState();
}

class _ModViewGardenPageState extends State<ModViewGardenPage> {

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
              GardenHeader(isModView: true,),
              gapH30,
              GardenTimeline(),
              GardenFooter(isModView: true,),
              gapH35
            ],
          ),
        ),
      )
    );
  }
}