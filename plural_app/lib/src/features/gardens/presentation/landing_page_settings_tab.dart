import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class LandingPageSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [],
            )
          ),
          gapH30,
          AppElevatedButton(
            callback: () {},
            label: LandingPageText.saveChanges,
          ),
          gapH10,
          AppTextButton(
            callback: logout,
            label: SignInPageText.logOut,
            positionalArguments: [context],
          )
        ],
      )
    );
  }
}