import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/user_settings_button.dart';

// Garden
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class GardenDialogViewForm extends StatelessWidget {
  const GardenDialogViewForm({
    super.key,
    required this.garden,
  });

  final Garden garden;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogHeader(
          firstHeaderButton: CloseDialogButton(),
          secondHeaderButton: UserSettingsButton(),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              AppTextFormFieldFilled(
                label: Strings.gardenNameLabel,
                value: garden.name,
              ),
            ]
          ),
        )
      ],
    );
  }
}