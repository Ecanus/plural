import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/forms.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog_header.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog_header_button.dart';

Future createEditableAskDialog(BuildContext context) {

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AskDialog(
        view: AskDialogCreateForm(),
        viewTitle: Strings.creatableAskDialogTitle
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

    final Widget submitFormButton = AskDialogHeaderButton(
      buttonNotifier: ValueNotifier<bool>(true),
      icon: Icon(Icons.add),
      label: Strings.createLabel,
      onPressed: () => submitCreate(context, _formKey, _askMap),
    );

    return Column(
      children: [
        AskDialogHeader(
          firstHeaderButton: ListedAsksButton(),
          secondHeaderButton: submitFormButton),
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
                        Expanded(
                          child: AppDatePickerFormField(
                            fieldName: AskField.deadlineDate,
                            label: Strings.askDeadlineDateLabel,
                            modelMap: _askMap,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          child: AppTextFormField(
                            fieldName: AskField.targetDonationSum,
                            formFieldType: FormFieldType.int,
                            label: Strings.askTargetDonationSumLabel,
                            maxLength: AppMaxLengthValues.max4,
                            modelMap: _askMap,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                      ],
                    ),
                    AppTextFormField(
                      fieldName: AskField.description,
                      label: Strings.askDescriptionLabel,
                      maxLength: AppMaxLengthValues.max250,
                      maxLines: null,
                      modelMap: _askMap,
                    ),
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