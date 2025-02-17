import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppTooltipIcon extends StatelessWidget {
  const AppTooltipIcon({
    super.key,
    this.dark = true,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.info_outline_rounded,
      color: dark ?
        Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSecondary,
      size: AppIconSizes.s15,
    );
  }
}