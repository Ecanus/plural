import 'package:flutter/material.dart';
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_checkbox_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/themes.dart';

// Ask
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/forms.dart';

Future createEditableAskDialog({
  required BuildContext context,
  required Ask ask
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
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
  late AppForm _appForm;

  late ValueNotifier<bool> _buttonNotifier;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _appForm = AppForm();

    _buttonNotifier = ValueNotifier<bool>(false);
  }

  void onChanged() {
    _buttonNotifier.value = _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    // final Widget submitFormButton = AppDialogHeaderButton(
    //   buttonNotifier: _buttonNotifier,
    //   icon: Icon(Icons.mode_edit_outlined),
    //   label: Strings.updateLabel,
    //   onPressed: () => submitUpdate(context, _formKey, _askMap),
    // );

    return Column(
      children: [
        EditableAskHeader(ask: widget.ask),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                key: _formKey,
                onChanged: () => onChanged(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.targetSum,
                            formFieldType: FormFieldType.int,
                            initialValue: widget.ask.targetSum.toString(),
                            label: Strings.askTargetSumLabel,
                            maxLength: AppMaxLengthValues.max4,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                        gapW20,
                        AppCurrencyPickerFormField()
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.description,
                      initialValue: widget.ask.description,
                      label: Strings.askDescriptionLabel,
                      maxLength: AppMaxLengthValues.max400,
                      maxLines: null,
                    ),
                    AppDatePickerFormField(
                      appForm: _appForm,
                      fieldName: AskField.deadlineDate,
                      initialValue: widget.ask.deadlineDate,
                      label: Strings.askDeadlineDateLabel,
                    ),
                    AppCheckboxFormField(
                        appForm: _appForm,
                        fieldName: AskField.targetMetDate,
                        formFieldType: FormFieldType.datetimeNow,
                        text: Strings.isTargetMetLabel,
                        value: widget.ask.isTargetMet,
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

class EditableAskHeader extends StatelessWidget {
  const EditableAskHeader({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p35),
      child: Column(
        children: [
          gapH35,
          VisibleOnTimelineLabel(isOnTimeline: ask.isOnTimeline),
        ]
      ),
    );
  }
}

class VisibleOnTimelineLabel extends StatelessWidget {
  const VisibleOnTimelineLabel({
    required this.isOnTimeline,
  });

  final bool isOnTimeline;

  @override
  Widget build(BuildContext context) {
    var color = isOnTimeline ?
      AppThemes.positiveColor : Theme.of(context).colorScheme.onPrimaryFixed;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          isOnTimeline ? Icons.local_florist : Icons.visibility_off_rounded,
          size: AppIconSizes.s25,
          color: color,
        ),
        gapW10,
        Text(
          isOnTimeline ?
            AskDialogLabels.isVisibleOnTimeline : AskDialogLabels.isNotVisibleOnTimeline,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          )
        )
      ],
    );
  }
}