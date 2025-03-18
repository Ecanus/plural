import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import '''
package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart''';
import '''
package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart''';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class GardenFooter extends StatelessWidget {
  final ValueNotifier<bool> _isFooterCollapsed = ValueNotifier<bool>(true);

  bool _toggleIsFooterCollapsed () {
    return _isFooterCollapsed.value = !_isFooterCollapsed.value;
  }

  @override
  Widget build(BuildContext context) {

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: AppElevations.e5,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.all(AppPaddings.p18),
      shape: CircleBorder(),
    );

    final showActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: _toggleIsFooterCollapsed,
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: AppIconSizes.s30
      ),
    );

    final hideActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: _toggleIsFooterCollapsed,
      child: Icon(
        Icons.close,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: AppIconSizes.s30
      ),
    );

    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _isFooterCollapsed,
            builder: (BuildContext context, bool value, Widget? child) {
              return value ?
                Center(child: showActionsButton) :
                AppBottomBar(hideActionsButton: hideActionsButton,);
            }
          ),
        ),
      ],
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.hideActionsButton
  });

  final Widget hideActionsButton;

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).colorScheme.onPrimary;
    var iconSize = AppButtonSizes.s25;

    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c350,
              height: AppConstraints.c40
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadii.r50),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                gapW10,
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.aspect_ratio),
                  iconSize: iconSize,
                  tooltip: GardenFooterText.asksTooltip,
                  onPressed: () => createListedAsksDialog(context),
                ),
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.settings),
                  iconSize: iconSize,
                  tooltip: GardenFooterText.settingsTooltip,
                  onPressed: () => createUserSettingsDialog(context),
                ),
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.people_alt_rounded),
                  iconSize: iconSize,
                  tooltip: GardenFooterText.usersTooltip,
                  onPressed: () => createListedUsersDialog(context),
                ),
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.local_florist),
                  iconSize: iconSize,
                  tooltip: GardenFooterText.gardensTooltip,
                  onPressed: () => createListedGardensDialog(context),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppPositions.pNg10,
            child: hideActionsButton,
          ),
        ],
      ),
    );
  }
}