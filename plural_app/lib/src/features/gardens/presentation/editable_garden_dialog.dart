import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header_button.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Garden
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/domain/forms.dart';

class GardenDialogEditForm extends StatefulWidget {
  const GardenDialogEditForm({
    super.key,
    required this.garden,
  });

  final Garden garden;

  @override
  State<GardenDialogEditForm> createState() => _GardenDialogEditFormState();
}

class _GardenDialogEditFormState extends State<GardenDialogEditForm> {
  late GlobalKey<FormState> _formKey;
  late Map _gardenMap;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _gardenMap = widget.garden.toMap();
  }

  @override
  Widget build(BuildContext context) {
    final Widget submitFormButton = AppDialogHeaderButton(
      buttonNotifier: ValueNotifier<bool>(true),
      icon: Icon(Icons.mode_edit_outlined),
      label: Strings.updateLabel,
      onPressed: () => submitUpdate(_formKey, _gardenMap),
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormFieldDeprecated(
                      fieldName: GardenField.name,
                      initialValue: widget.garden.name,
                      maxLength: AppMaxLengthValues.max75,
                      label: Strings.gardenNameLabel,
                      modelMap: _gardenMap,
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }
}