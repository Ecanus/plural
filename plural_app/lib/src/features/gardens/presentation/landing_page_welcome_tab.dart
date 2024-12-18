import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

class LandingPageWelcomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppButtonSizes.s300,
                height: AppButtonSizes.s50,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.grass),
                  label: Text(LandingPageLabels.createGarden),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          gapH30,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppButtonSizes.s300,
                height: AppButtonSizes.s50,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.mail),
                  label: Text(LandingPageLabels.seeInvites),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}