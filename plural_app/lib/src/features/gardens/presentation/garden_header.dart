import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenHeader extends StatelessWidget {
  const GardenHeader({
    this.isAdminPage = false,
  });

  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              isAdminPage ? AdminPageIcon() : SizedBox(),
              isAdminPage ? gapH15 : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Theme.of(context).colorScheme.onTertiary,
                    icon: const Icon(Icons.sync),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false).refreshTimelineAsks();
                    },
                  ),
                  gapH5,
                  Text(
                    Provider.of<AppState>(context).currentGarden!.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isAdminPage ? Theme.of(context).colorScheme.onPrimary : null,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.s25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              GardenClock(),
            ],
          )
        ),
      ],
    );
  }
}

class AdminPageIcon extends StatelessWidget {
  const AdminPageIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.security,
      color: Theme.of(context).colorScheme.onSurface,
      size: AppIconSizes.s25,
    );
  }
}