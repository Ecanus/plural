import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/forms.dart';
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

Future createEditableAskDialog(BuildContext context) {

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        view: AskDialogCreateForm(),
      );
    }
  );
}

class AskDialogCreateForm extends StatefulWidget {
  const AskDialogCreateForm({
    super.key,
  });

  @override
  State<AskDialogCreateForm> createState() => _AskDialogCreateFormState();
}

class _AskDialogCreateFormState extends State<AskDialogCreateForm> {
  late GlobalKey<FormState> _formKey;
  late Map _askMap;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _askMap = Ask.emptyMap();
  }

  @override
  Widget build(BuildContext context) {

    final Widget submitFormButton = AppDialogHeaderButton(
      buttonNotifier: ValueNotifier<bool>(true),
      icon: Icon(Icons.add),
      label: AskDialogLabels.createLabel,
      onPressed: () => submitCreate(context, _formKey, _askMap),
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
                    Row(
                      children: [
                        // Expanded(
                        //   child: AppDatePickerFormField(
                        //     fieldName: AskField.deadlineDate,
                        //     label: Strings.askDeadlineDateLabel,
                        //     modelMap: _askMap,
                        //   ),
                        // ),
                        // gapW20,
                        // Expanded(
                        //   child: AppTextFormFieldDeprecated(
                        //     fieldName: AskField.targetSum,
                        //     formFieldType: FormFieldType.int,
                        //     label: Strings.askTargetSumLabel,
                        //     maxLength: AppMaxLengthValues.max4,
                        //     modelMap: _askMap,
                        //     textFieldType: TextFieldType.digitsOnly,
                        //   ),
                        // ),
                      ],
                    ),
                    // AppTextFormFieldDeprecated(
                    //   fieldName: AskField.description,
                    //   label: Strings.askDescriptionLabel,
                    //   maxLength: AppMaxLengthValues.max400,
                    //   maxLines: null,
                    //   modelMap: _askMap,
                    // ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}