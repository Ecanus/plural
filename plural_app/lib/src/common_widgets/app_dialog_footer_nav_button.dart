import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/form_values.dart';

enum NavButtonDirection {
  left,
  right
}

class AppDialogFooterNavButton extends StatelessWidget {
  const AppDialogFooterNavButton({
    super.key,
    required this.callback,
    required this.dialogIcon,
    required this.direction,
    required this.isMouseHovered,
    required this.tooltipMessage,
  });

  final Function callback;
  final IconData dialogIcon;
  final NavButtonDirection direction;
  final bool isMouseHovered;
  final String tooltipMessage;

  @override
  Widget build(BuildContext context) {
    var isLeft = direction == NavButtonDirection.left;

    var alignment = isLeft ?
      MainAxisAlignment.start : MainAxisAlignment.end;

    var arrowIcon = isLeft ?
      Icons.keyboard_arrow_left_rounded : Icons.keyboard_arrow_right_rounded;

    return Expanded(
      child: GestureDetector(
        onTap: () => callback(),
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
              duration: FormValues.navButtonFadeDuration,
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