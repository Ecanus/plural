import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Common Functions
import 'package:plural_app/src/common_functions/app_responsiveness.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

class GardenPage extends StatefulWidget {
  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: GetIt.instance<AppState>(),
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              gapH40,
              GardenHeader(),
              gapH30,
              GardenTimeline(),
              getResponsiveUiValue(context, ResponsiveUiKeys.gardenPageVerticalGap),
              GardenFooter(),
              getResponsiveUiValue(context, ResponsiveUiKeys.gardenPageVerticalGap),
            ],
          ),
        ),
      )
    );
  }
}