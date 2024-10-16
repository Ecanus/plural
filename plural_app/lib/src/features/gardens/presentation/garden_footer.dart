import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

/// Parent Widget of the AppBottomBar and all widgets
/// at the bottom of the App.
class GardenFooter extends StatelessWidget {
  final ValueNotifier<bool> _isFooterCollapsed = ValueNotifier<bool>(true);

  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.onPrimaryColor,
    elevation: AppElevations.e5,
    iconColor: AppColors.secondaryColor,
    padding: EdgeInsets.all(AppPaddings.p18),
    shape: CircleBorder(),
  );

  bool toggleIsFooterCollapsed () {
    return _isFooterCollapsed.value = !_isFooterCollapsed.value;
  }

  @override
  Widget build(BuildContext context) {
    final showActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: toggleIsFooterCollapsed,
      child: Icon(Icons.add, size: AppIconSizes.s30),
    );

    final hideActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: toggleIsFooterCollapsed,
      child: Icon(Icons.close, size: AppIconSizes.s30),
    );

    return ValueListenableBuilder(
      valueListenable: _isFooterCollapsed,
      builder: (BuildContext context, bool value, Widget? child) {
        return value ?
          Center(child: showActionsButton) :
          AppBottomBar(hideActionsButton: hideActionsButton,);
      }
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.hideActionsButton
  });

  final Widget hideActionsButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c350,
              height: AppConstraints.c50
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadii.r50),
              color: AppColors.darkGrey1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                gapW10,
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.library_add),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipAskMenu,
                  onPressed: () => createListedAsksDialog(context),
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.settings),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipSettings,
                  onPressed: () {},
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.mail),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipInvitations,
                  onPressed: () {},
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.grass),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipGardenMenu,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: AppPositions.pNeg10,
            child: hideActionsButton,
          ),
        ],
      ),
    );
  }
}