import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/image_paths.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPaddings.p40),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSecondary,
          BlendMode.modulate
        ),
        child: Image.asset(ImagePaths.appLogo)
      ),
    );
  }
}