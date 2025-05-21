import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer_nav_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

const blurRadius = 5.0;
const spreadRadius = 1.0;
const offset = Offset(0, -1.0); // Top

class AppDialogFooterBuffer extends StatelessWidget {
  const AppDialogFooterBuffer({
    required this.buttons,
  });

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return buttons.isEmpty ?
      SizedBox()
      : Container(
        constraints: BoxConstraints.expand(
          width: AppConstraints.c600,
          height: AppConstraints.c60,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              offset: offset,
            ),
          ],
          color: Theme.of(context).colorScheme.surfaceBright,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons,
        ),
      );
  }
}

class AppDialogNavFooter extends StatefulWidget {
  const AppDialogNavFooter({
    required this.leftDialogIcon,
    required this.leftNavCallback,
    required this.leftTooltipMessage,
    required this.rightDialogIcon,
    required this.rightNavCallback,
    required this.rightTooltipMessage,
    required this.title,
  });

  final IconData leftDialogIcon;
  final Function leftNavCallback;
  final String leftTooltipMessage;

  final IconData rightDialogIcon;
  final Function rightNavCallback;
  final String rightTooltipMessage;

  final String title;

  @override
  State<AppDialogNavFooter> createState() => _AppDialogNavFooterState();
}

class _AppDialogNavFooterState extends State<AppDialogNavFooter> {
  bool _isMouseHovered = false;

  void _mouseExit(PointerEvent details) {
    setState(() { _isMouseHovered = false; });
  }

  void _mouseEnter(PointerEvent details) {
    setState(() { _isMouseHovered = true; });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _mouseEnter,
      onExit: _mouseExit,
      child: Container(
        constraints: BoxConstraints.expand(
          width: AppConstraints.c800,
          height: AppConstraints.c100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppBorderRadii.r15),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: blurRadius,
              offset: offset,
              spreadRadius: spreadRadius,
            ),
          ],
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p35),
        child: Row(
          children: [
            AppDialogFooterNavButton(
              callback: widget.leftNavCallback,
              dialogIcon: widget.leftDialogIcon,
              direction: NavButtonDirection.left,
              isMouseHovered: _isMouseHovered,
              tooltipMessage: widget.leftTooltipMessage,
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: AppFontSizes.s25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            AppDialogFooterNavButton(
              callback: widget.rightNavCallback,
              dialogIcon: widget.rightDialogIcon,
              direction: NavButtonDirection.right,
              isMouseHovered: _isMouseHovered,
              tooltipMessage: widget.rightTooltipMessage,
            ),
          ],
        )
      ),
    );
  }
}

class AppDialogFooter extends StatelessWidget {
  const AppDialogFooter({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: AppConstraints.c800,
        height: AppConstraints.c100,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppBorderRadii.r15),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: blurRadius,
            offset: offset,
            spreadRadius: spreadRadius,
          ),
        ],
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppFontSizes.s25,
            fontWeight: FontWeight.bold,
          ),
        )
      )
    );
  }
}