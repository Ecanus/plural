import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_header_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/domain/forms.dart';

class GardenDialogCreateForm extends StatefulWidget {
  const GardenDialogCreateForm({
    super.key
  });

  @override
  State<GardenDialogCreateForm> createState() => _GardenDialogCreateFormState();
}

class _GardenDialogCreateFormState extends State<GardenDialogCreateForm> {
  late GlobalKey<FormState> _formKey;
  late Map _gardenMap;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _gardenMap = Garden.emptyMap();
  }

  @override
  Widget build(BuildContext context) {

    final Widget submitFormButton = AppDialogHeaderButton(
      buttonNotifier: ValueNotifier<bool>(true),
      icon: Icon(Icons.add),
      label: AskDialogLabels.createLabel,
      onPressed: () => submitCreate(_formKey, _gardenMap),
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
                    // AppTextFormFieldDeprecated(
                    //   fieldName: GardenField.name,
                    //   label: Strings.gardenNameLabel,
                    //   modelMap: _gardenMap,
                    // )
                  ]
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}