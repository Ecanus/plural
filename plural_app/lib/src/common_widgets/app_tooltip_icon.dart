import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppTooltipIcon extends StatelessWidget {
  const AppTooltipIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.info_outline_rounded,
      color: Theme.of(context).colorScheme.primary,
      size: AppIconSizes.s15,
    );
  }
}