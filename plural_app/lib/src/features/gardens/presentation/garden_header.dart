import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:plural_app/src/app.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

class GardenHeader extends StatelessWidget {
  const GardenHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var headerText = Strings.gardenHeaderText1 + appState.testUser.firstName;

    return Expanded(
      flex: AppFlexes.f6,
      child: Column(
        children: [
          Text(
              headerText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.s25,
              ),
              textAlign: TextAlign.center,
          ),
          GardenClock(),
        ],
      )
    );
  }
}