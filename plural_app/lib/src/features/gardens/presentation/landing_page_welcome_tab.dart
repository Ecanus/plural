import 'package:flutter/material.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

class LandingPageWelcomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPaddings.p80,
        left: AppPaddings.p50,
        right: AppPaddings.p50,
      ),
      child: Column(
        children: [
          AppElevatedButton(
            callback: () {},
            icon: Icons.mail,
            label: LandingPageLabels.seeInvites
          ),
          gapH10,
          AppTextButton(
            callback: () {},
            fontSize: AppFontSizes.s14,
            label: LandingPageLabels.createGarden
          )
        ]
      ),
    );
  }
}