import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_logo.dart';
import 'package:plural_app/src/common_widgets/app_text_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/routes.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({
    this.previousRoute,
  });

  final String? previousRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block,
              color: Theme.of(context).colorScheme.primaryContainer,
              size: AppIconSizes.s110,
            ),
            Text(
              UnauthorizedPageText.messageHeader,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            gapH15,
            Text(
              UnauthorizedPageText.messageBody,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            gapH30,
            AppTextButton(
              callback: GoRouter.of(context).go,
              fontSize: AppFontSizes.s20,
              label: UnauthorizedPageText.buttonText,
              positionalArguments: [previousRoute ?? Routes.signIn],
            )
          ],
        )
      ),
      bottomSheet: MediaQuery.sizeOf(context).height > AppHeights.h800 ?
        AppLogo()
        : null,
    );
  }
}