import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

class LandingPageSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                CheckboxListTile(
                  secondary: const Icon(Icons.assessment_rounded),
                  title: Text("CheckboxList Tile Test!"),
                  value: false,
                  onChanged: (bool? value) {}
                ),
                Slider(
                  value: 0.4,
                  onChanged: (double value) {}
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.add_alert),
                  title: Text("SwitchListTile Test"),
                  value: true,
                  onChanged: (bool value) {}
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.add_alert),
                  title: Text("SwitchListTile Test"),
                  value: false,
                  onChanged: (bool value) {}
                ),
                CheckboxListTile(
                  secondary: const Icon(Icons.assessment_rounded),
                  title: Text("CheckboxList Tile Test!"),
                  value: false,
                  onChanged: (bool? value) {}
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.add_alert),
                  title: Text("SwitchListTile Test"),
                  value: true,
                  onChanged: (bool value) {}
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.add_alert),
                  title: Text("SwitchListTile Test"),
                  value: false,
                  onChanged: (bool value) {}
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.add_alert),
                  title: Text("SwitchListTile Test"),
                  value: false,
                  onChanged: (bool value) {}
                ),
                CheckboxListTile(
                  secondary: const Icon(Icons.assessment_rounded),
                  title: Text("CheckboxList Tile Test!"),
                  value: true,
                  onChanged: (bool? value) {}
                ),
                CheckboxListTile(
                  secondary: const Icon(Icons.assessment_rounded),
                  title: Text("CheckboxList Tile Test!"),
                  value: true,
                  onChanged: (bool? value) {}
                ),
              ],
            )
          ),
          gapH30,
          AppElevatedButton(
            callback: () {},
            label: LandingPageLabels.saveChanges,
          ),
          gapH10,
          AppTextButton(
            callback: logout,
            label: SignInLabels.logOut,
            positionalArguments: [context],
          )
        ],
      )
    );
  }
}