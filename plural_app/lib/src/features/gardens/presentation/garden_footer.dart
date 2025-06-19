import 'dart:math';

import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart''';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/current_garden_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class GardenFooter extends StatefulWidget {
  @override
  State<GardenFooter> createState() => _GardenFooterState();
}

class _GardenFooterState extends State<GardenFooter>
  with TickerProviderStateMixin{
  bool _isMouseHovered = false;

  // Left button
  late final AnimationController _leftButtonAnimationController;
  late final Animation<Offset> _leftButtonOffsetAnimation;

  // Right button
  late final AnimationController _rightButtonAnimationController;
  late final Animation<Offset> _rightButtonOffsetAnimation;

  @override
  void initState() {
    super.initState();

    // AnimationControllers
    _leftButtonAnimationController = AnimationController(
      duration: AppDurations.ms250,
      vsync: this,
    );
    _rightButtonAnimationController = AnimationController(
      duration: AppDurations.ms250,
      vsync: this,
    );

    // OffsetAnimations
    _leftButtonOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, AppPaddings.p5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _leftButtonAnimationController,
        curve: Curves.easeOutCubic
    ));
    _rightButtonOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, AppPaddings.p5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _rightButtonAnimationController,
        curve: Curves.easeOutCubic
    ));
  }

  void _mouseEnter(_) => setState(() {
    _isMouseHovered = true;

    final delayValues = [
      Duration(milliseconds: 0),
      Duration(milliseconds: (Random().nextInt(4) + 1) * 10) // range of 10 - 40
    ]..shuffle();

    Future.delayed(delayValues[0], () {
      _leftButtonAnimationController.forward();
    });
    Future.delayed(delayValues[1], () {
      _rightButtonAnimationController.forward();
    });
  });

  void _mouseExit(_) => setState(() {
    _isMouseHovered = false;

    _leftButtonAnimationController.reverse();
    _rightButtonAnimationController.reverse();
  });

  @override
  void dispose() {
    _leftButtonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AppBottomBar(
          isMouseHovered: _isMouseHovered,
          leftButtonOffsetAnimation: _leftButtonOffsetAnimation,
          rightButtonOffsetAnimation: _rightButtonOffsetAnimation
        ),
        MouseRegion(
          onEnter: _mouseEnter,
          onExit: _mouseExit,
          hitTestBehavior: HitTestBehavior.translucent,
          child: Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c700,
              height: AppConstraints.c150
            ),
          ),
        ),
      ],
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.isMouseHovered,
    required this.leftButtonOffsetAnimation,
    required this.rightButtonOffsetAnimation,
  });

  final bool isMouseHovered;
  final Animation<Offset> leftButtonOffsetAnimation;
  final Animation<Offset> rightButtonOffsetAnimation;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: leftButtonOffsetAnimation,
          child: AnimatedOpacity(
            duration: AppDurations.ms80,
            opacity: isMouseHovered ? 1.0 : 0.0,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
              child: IconButton(
                color: iconColor,
                icon: const Icon(Icons.local_florist),
                iconSize: AppButtonSizes.s25,
                tooltip: GardenFooterText.gardensTooltip,
                onPressed: () => createCurrentGardenDialog(context),
              ),
            ),
          ),
        ),
        gapW20,
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: AppBorderRadii.r30,
          child: IconButton(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            icon: const Icon(Icons.add),
            iconSize: AppIconSizes.s30,
            tooltip: GardenFooterText.asksTooltip,
            onPressed: () => createCreatableAskDialog(context),
          ),
        ),
        gapW20,
        SlideTransition(
          position: rightButtonOffsetAnimation,
          child: AnimatedOpacity(
            duration: AppDurations.ms80,
            opacity: isMouseHovered ? 1.0 : 0.0,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
              child: IconButton(
                color: iconColor,
                icon: const Icon(Icons.settings),
                iconSize: AppButtonSizes.s25,
                tooltip: GardenFooterText.settingsTooltip,
                onPressed: () => createUserSettingsDialog(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}