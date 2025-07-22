import 'dart:math';

import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Auth
import 'package:plural_app/src/features/gardens/presentation/app_bottom_bar.dart';

class GardenFooter extends StatefulWidget {
  const GardenFooter({
    this.isAdminPage = false,
  });

  final bool isAdminPage;

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

  void _mouseEnter(dynamic _) => setState(() {
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

  void _mouseExit(dynamic _) => setState(() {
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
          isAdminPage: widget.isAdminPage,
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
