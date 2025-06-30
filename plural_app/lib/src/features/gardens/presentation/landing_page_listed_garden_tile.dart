import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class LandingPageListedGardenTile extends StatelessWidget {
  const LandingPageListedGardenTile({
    required this.garden,
  });

  final Garden garden;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
        ),
        tileColor: Theme.of(context).colorScheme.secondaryFixed,
        title: Text(
          garden.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        onTap: () {
          GetIt.instance<AppState>().setGardenAndReroute(context, garden);
        }
      ),
    );
  }
}