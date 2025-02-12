import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

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