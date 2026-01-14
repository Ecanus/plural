import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_users_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/user_settings_view.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/admin_current_garden_settings_view.dart';
import 'package:plural_app/src/features/gardens/presentation/admin_options_view.dart';
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

typedef ButtonLayout = ({
  Widget leftButton,
  Widget middleButton,
  Widget rightButton,
});

ButtonLayout _getButtonLayout(BuildContext context, { isAdminPage = false }) {
  if (isAdminPage) {
    final iconColor = Theme.of(context).colorScheme.surfaceDim;

    return (
      leftButton: CreateAdminCurrentGardenSettingsDialogButton(iconColor: iconColor),
      middleButton: CreateAdminOptionsDialogButton(),
      rightButton: CreateAdminListedUsersDialogButton(iconColor: iconColor)
    );
  } else {
    final iconColor = Theme.of(context).colorScheme.onPrimary;

    return (
      leftButton: CreateCurrentGardenSettingsDialogButton(iconColor: iconColor),
      middleButton: CreateCreateAskDialogButton(),
      rightButton: CreateUserSettingsDialogButton(iconColor: iconColor)
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.isAdminPage,
    required this.isMouseHovered,
    required this.leftButtonOffsetAnimation,
    required this.rightButtonOffsetAnimation,
  });

  final bool isAdminPage;
  final bool isMouseHovered;
  final Animation<Offset> leftButtonOffsetAnimation;
  final Animation<Offset> rightButtonOffsetAnimation;

  @override
  Widget build(BuildContext context) {
    final buttonLayout = _getButtonLayout(context, isAdminPage: isAdminPage);

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
        tooltip: GardenPageBottomBarText.settingsTooltip,
        onPressed: () => createUserSettingsDialog(context),
      ),
    );
  }
}

class CreateCreateAskDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: AppBorderRadii.r30,
      child: IconButton(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.add),
        iconSize: AppIconSizes.s30,
        tooltip: GardenPageBottomBarText.asksTooltip,
        onPressed: () => createCreateAskDialog(context),
      ),
    );
  }
}

class CreateCurrentGardenSettingsDialogButton extends StatelessWidget {
  const CreateCurrentGardenSettingsDialogButton({
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
        tooltip: GardenPageBottomBarText.gardensTooltip,
        onPressed: () => createCurrentGardenSettingsDialog(context),
      ),
    );
  }
}

class CreateAdminCurrentGardenSettingsDialogButton extends StatelessWidget {
  const CreateAdminCurrentGardenSettingsDialogButton({
    required this.iconColor,
  });

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      child: IconButton(
        color: iconColor,
        icon: const Icon(Icons.local_florist),
        iconSize: AppButtonSizes.s25,
        tooltip: AdminPageBottomBarText.currentGardenSettingsTooltip,
        onPressed: () => createAdminCurrentGardenSettingsDialog(context),
      ),
    );
  }
}

class CreateAdminOptionsDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      radius: AppBorderRadii.r30,
      child: IconButton(
        color: Theme.of(context).colorScheme.surfaceDim,
        icon: const Icon(Icons.security),
        iconSize: AppIconSizes.s30,
        tooltip: AdminPageBottomBarText.optionsTooltip,
        onPressed: () => createAdminOptionsDialog(context),
      ),
    );
  }
}

class CreateAdminListedUsersDialogButton extends StatelessWidget {
  const CreateAdminListedUsersDialogButton({
    required this.iconColor,
  });

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      child: IconButton(
        color: iconColor,
        icon: const Icon(Icons.people_alt),
        iconSize: AppButtonSizes.s25,
        tooltip: AdminPageBottomBarText.usersTooltip,
        onPressed: () => createAdminListedUsersDialog(context),
      ),
    );
  }
}
