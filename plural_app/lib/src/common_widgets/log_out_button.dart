import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50,
      ),
      child: OutlinedButton(
        onPressed: () => logout(context),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: Theme.of(context).colorScheme.primary
            )
          )
        ),
        child: const Text(SignInPageText.logOut)
      ),
    );
  }
}