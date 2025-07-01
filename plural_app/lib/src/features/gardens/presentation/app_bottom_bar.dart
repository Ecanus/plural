import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';

// Auth
import 'package:plural_app/src/features/gardens/presentation/user_settings_dialog.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/current_garden_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

typedef ButtonLayout = ({
  Widget leftButton,
  Widget middleButton,
  Widget rightButton,
});

ButtonLayout _getButtonLayout(BuildContext context, { isModView = false }) {
  final iconColor = Theme.of(context).colorScheme.onPrimary;

  if (isModView) {
    return (
      leftButton: CreateCurrentGardenDialogButton(iconColor: iconColor),
      middleButton: CreateCreatableAskDialogButton(),
      rightButton: CreateUserSettingsDialogButton(iconColor: iconColor)
    );
  } else {
    return (
      leftButton: CreateCurrentGardenDialogButton(iconColor: iconColor),
      middleButton: CreateCreatableAskDialogButton(),
      rightButton: CreateUserSettingsDialogButton(iconColor: iconColor)
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.isModView,
    required this.isMouseHovered,
    required this.leftButtonOffsetAnimation,
    required this.rightButtonOffsetAnimation,
  });

  final bool isModView;
  final bool isMouseHovered;
  final Animation<Offset> leftButtonOffsetAnimation;
  final Animation<Offset> rightButtonOffsetAnimation;

  @override
  Widget build(BuildContext context) {
    final buttonLayout = _getButtonLayout(context, isModView: isModView);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: leftButtonOffsetAnimation,
          child: AnimatedOpacity(
            duration: AppDurations.ms80,
            opacity: isMouseHovered ? 1.0 : 0.0,
            child: buttonLayout.leftButton,
          ),
        ),
        gapW20,
        buttonLayout.middleButton,
        gapW20,
        SlideTransition(
          position: rightButtonOffsetAnimation,
          child: AnimatedOpacity(
            duration: AppDurations.ms80,
            opacity: isMouseHovered ? 1.0 : 0.0,
            child: buttonLayout.rightButton,
          ),
        ),
      ],
    );
  }
}

class CreateUserSettingsDialogButton extends StatelessWidget {
  const CreateUserSettingsDialogButton({
    required this.iconColor,
  });

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
      child: IconButton(
        color: iconColor,
        icon: const Icon(Icons.settings),
        iconSize: AppButtonSizes.s25,
        tooltip: GardenFooterText.settingsTooltip,
        onPressed: () => createUserSettingsDialog(context),
      ),
    );
  }
}

class CreateCreatableAskDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: AppBorderRadii.r30,
      child: IconButton(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.add),
        iconSize: AppIconSizes.s30,
        tooltip: GardenFooterText.asksTooltip,
        onPressed: () => createCreatableAskDialog(context),
      ),
    );
  }
}

class CreateCurrentGardenDialogButton extends StatelessWidget {
  const CreateCurrentGardenDialogButton({
    required this.iconColor,
  });

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
      child: IconButton(
        color: iconColor,
        icon: const Icon(Icons.local_florist),
        iconSize: AppButtonSizes.s25,
        tooltip: GardenFooterText.gardensTooltip,
        onPressed: () => createCurrentGardenDialog(context),
      ),
    );
  }
}
