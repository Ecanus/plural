import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_checkbox_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

// Ask
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/forms.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog_header.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog_header_button.dart';

Future createEditableAskDialog({
  required BuildContext context,
  required Ask ask
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AskDialog(
        view: AskDialogEditForm(ask: ask),
        viewTitle: Strings.editableAskDialogTitle,
      );
    }
  );
}

class AskDialogEditForm extends StatefulWidget {
  const AskDialogEditForm({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  State<AskDialogEditForm> createState() => _AskDialogEditFormState();
}

class _AskDialogEditFormState extends State<AskDialogEditForm> {
  late GlobalKey<FormState> _formKey;
  late Map _askMap;

  late ValueNotifier<bool> _buttonNotifier;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _askMap = widget.ask.toMap();

    _buttonNotifier = ValueNotifier<bool>(false);
  }

  void onChanged() {
    _buttonNotifier.value = _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final Widget submitFormButton = AskDialogHeaderButton(
      buttonNotifier: _buttonNotifier,
      icon: Icon(Icons.mode_edit_outlined),
      label: Strings.updateLabel,
      onPressed: () => submitUpdate(context, _formKey, _askMap),
    );

    return Column(
      children: [
        AskDialogHeader(primaryHeaderButton: submitFormButton),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                key: _formKey,
                onChanged: () => onChanged(),
                child: Column(
                  children: [
                    AppCheckboxFormField(
                      fieldName: AskField.fullySponsoredDate,
                      formFieldType: FormFieldType.datetimeNow,
                      modelMap: _askMap,
                      text: Strings.isAskFullySponsoredLabel,
                      value: widget.ask.isFullySponsored,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppDatePickerFormField(
                            fieldName: AskField.deadlineDate,
                            initialValue: widget.ask.deadlineDate,
                            label: Strings.askDeadlineDateLabel,
                            modelMap: _askMap,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          child: AppTextFormField(
                            fieldName: AskField.targetDonationSum,
                            formFieldType: FormFieldType.int,
                            initialValue: widget.ask.targetDonationSum.toString(),
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
                      initialValue: widget.ask.description,
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