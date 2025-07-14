import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

enum NavButtonDirection {
  left,
  right
}

class AppDialogFooterNavButton extends StatelessWidget {
  const AppDialogFooterNavButton({
    this.actionCallback,
    this.callback,
    required this.dialogIcon,
    required this.direction,
    required this.isMouseHovered,
    required this.tooltipMessage,
  });

  final void Function(BuildContext context)? actionCallback;
  final void Function()? callback;
  final IconData dialogIcon;
  final NavButtonDirection direction;
  final bool isMouseHovered;
  final String tooltipMessage;

  @override
  Widget build(BuildContext context) {
    final isLeft = direction == NavButtonDirection.left;

    final alignment = isLeft ?
      MainAxisAlignment.start : MainAxisAlignment.end;

    final arrowIcon = isLeft ?
      Icons.keyboard_arrow_left_rounded : Icons.keyboard_arrow_right_rounded;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => {
          actionCallback != null ? actionCallback!(context) : callback!()
        },
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            isLeft ? Icon(
              arrowIcon,
              color: Theme.of(context).colorScheme.onSecondary,
              size: AppIconSizes.s40,
            )
            : SizedBox(),
            AnimatedOpacity(
              duration: AppDurations.ms120,
              opacity: isMouseHovered ? 1.0 : 0.0,
              child: Tooltip(
                message: tooltipMessage,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  child: Icon(
                    dialogIcon,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  )
                ),
              ),
            ),
            !isLeft ? Icon(
              arrowIcon,
              color: Theme.of(context).colorScheme.onSecondary,
              size: AppIconSizes.s40,
            )
            : SizedBox()
          ],
        ),
      ),
    );
  }
}