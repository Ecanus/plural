import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                Provider.of<AppState>(context).currentGarden!.name,
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
        ),
      ],
    );
  }
}