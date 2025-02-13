import 'package:flutter/material.dart';
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_checkbox_list_tile_form_field.dart';
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

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
        view: AskDialogEditForm(ask: ask)
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

    _appForm = AppForm.fromMap(widget.ask.toMap());
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); }
    );

    _buttonNotifier = ValueNotifier<bool>(false);
  }

  void onChanged() {
    _buttonNotifier.value = _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
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
                            label: AskDialogLabels.targetSum,
                            maxLength: AppMaxLengthValues.max4,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.boon,
                            formFieldType: FormFieldType.int,
                            initialValue: widget.ask.boon.toString(),
                            label: AskDialogLabels.boon,
                            maxLength: AppMaxLengthValues.max4,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          flex: 2,
                          child: AppCurrencyPickerFormField(
                            appForm: _appForm,
                            fieldName: AskField.currency,
                            initialValue: widget.ask.currency,
                            label: AskDialogLabels.currency,
                          )
                        )
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.description,
                      initialValue: widget.ask.description,
                      label: AskDialogLabels.description,
                      maxLength: AppMaxLengthValues.max400,
                      maxLines: null,
                    ),
                    AppDatePickerFormField(
                      appForm: _appForm,
                      fieldName: AskField.deadlineDate,
                      initialValue: widget.ask.deadlineDate,
                      label: AskDialogLabels.deadlineDate,
                    ),
                    gapH50,
                    AppCheckboxListTileFormField(
                      appForm: _appForm,
                      fieldName: AskField.targetMetDate,
                      formFieldType: FormFieldType.datetimeNow,
                      text: AskDialogLabels.isTargetMet,
                      value: widget.ask.isTargetMet,
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToListedAsksViewButton(),
            SubmitUpdateButton(formKey: _formKey, appForm: _appForm,),
          ]
        ),
        AppDialogFooter(title: AskDialogTitles.editAsk)
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
          gapH15,
          IsTargetMetLabel(targetMetDateString: ask.formattedTargetMetDate,),
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

class IsTargetMetLabel extends StatelessWidget {
  const IsTargetMetLabel({
    required this.targetMetDateString,
  });

  final String targetMetDateString;

  @override
  Widget build(BuildContext context) {
    var isTargetMet = targetMetDateString.isNotEmpty;
    var color = isTargetMet ?
      Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.onPrimaryFixed;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          isTargetMet ? Icons.check : Icons.not_interested,
          size: AppIconSizes.s25,
          color: color,
        ),
        gapW10,
        Text(
          isTargetMet ?
            AskDialogLabels.targetIsMet : AskDialogLabels.targetIsNotMet,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          )
        )
      ],
    );
  }
}

class SubmitUpdateButton extends StatelessWidget {
  SubmitUpdateButton({
    required this.appForm,
    required this.formKey,
  });

  final AppForm appForm;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AskDialogTooltips.saveChanges,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.surface,
          shape: CircleBorder(),
        ),
        onPressed: () => submitUpdate(context, formKey, appForm),
        child: Icon(Icons.save_alt)
      ),
    );
  }
}