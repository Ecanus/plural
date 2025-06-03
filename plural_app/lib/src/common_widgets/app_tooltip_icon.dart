import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppTooltipIcon extends StatelessWidget {
  const AppTooltipIcon({
    this.isDark = true,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.info_outline_rounded,
      color: isDark ?
        Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSecondary,
      size: AppIconSizes.s15,
    );
  }
}