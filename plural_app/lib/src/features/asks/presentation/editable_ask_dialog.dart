import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_functions/input_formatters.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_checkbox_list_tile_form_field.dart';
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/themes.dart';

// Ask
import 'package:plural_app/src/features/asks/data/forms.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

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
    required this.ask,
  });

  final Ask ask;

  @override
  State<AskDialogEditForm> createState() => _AskDialogEditFormState();
}

class _AskDialogEditFormState extends State<AskDialogEditForm> {
  late AppForm _appForm;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appForm = AppForm.fromMap(widget.ask.toMap());
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); }
    );

    _formKey = GlobalKey<FormState>();
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
                child: Column(
                  children: [
                    AppDatePickerFormField(
                      appForm: _appForm,
                      fieldName: AskField.deadlineDate,
                      initialValue: widget.ask.deadlineDate,
                      label: AskDialogText.deadlineDate,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.targetSum,
                            formFieldType: FormFieldType.digitsOnly,
                            initialValue: widget.ask.targetSum.toString(),
                            label: AskDialogText.targetSum,
                            maxLength: AppMaxLengths.max4,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.boon,
                            formFieldType: FormFieldType.digitsOnly,
                            initialValue: widget.ask.boon.toString(),
                            label: AskDialogText.boon,
                            maxLength: AppMaxLengths.max4,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          flex: AppFlexes.f2,
                          child: AppCurrencyPickerFormField(
                            appForm: _appForm,
                            fieldName: AskField.currency,
                            initialValue: widget.ask.currency,
                            label: AskDialogText.currency,
                          )
                        )
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.description,
                      initialValue: widget.ask.description,
                      label: AskDialogText.description,
                      maxLength: AppMaxLengths.max400,
                      maxLines: null,
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.instructions,
                      initialValue: widget.ask.instructions,
                      label: AskDialogText.instructions,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                    ),
                    gapH30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppCheckboxListTileFormField(
                          appForm: _appForm,
                          fieldName: AskField.targetMetDate,
                          formFieldType: FormFieldType.datetimeNow,
                          text: AskDialogText.targetMet,
                          value: widget.ask.isTargetMet,
                        ),
                      ],
                    ),
                    Visibility.maintain( // Hidden form field. Always saves type == monetary for now
                      visible: false,
                      child: AppTextFormField(
                        appForm: _appForm,
                        fieldName: AskField.type,
                        initialValue: AskType.monetary.name, // Hardcoded value for now
                        label: AskDialogText.type,
                      ),
                    ),
                    DeleteAskButton(appForm: _appForm),
                  ],
                ),
              ),
            ]
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToListedAsksViewButton(),
            AppDialogFooterBufferSubmitButton(
              callback: submitUpdate,
              positionalArguments: [context, _formKey, _appForm],
            ),
          ]
        ),
        AppDialogFooter(title: AppDialogFooterText.editAsk)
      ],
    );
  }
}

class DeleteAskButton extends StatelessWidget {
  const DeleteAskButton({
    required this.appForm,
  });

  final AppForm appForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50
      ),
      child: FilledButton.icon(
        icon: const Icon(Icons.delete),
        label: const Text(AskDialogText.deleteAsk),
        onPressed: () => showConfirmDeleteAskDialog(context, appForm),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
           Theme.of(context).colorScheme.error
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          )
        ),
      ),
    );
  }
}

class ConfirmDeleteAskDialog extends StatelessWidget {
  const ConfirmDeleteAskDialog({
    required this.appForm
  });

  final AppForm appForm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p20,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c400,
          height: AppConstraints.c180
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AskDialogText.confirmDeleteAsk,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            gapH35,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
                        )
                      ),
                    ),
                    child: Text(
                      AskDialogText.cancelConfirmDeleteAsk,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                    )
                  ),
                ),
                gapW15,
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      submitDelete(context, appForm);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.error
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
                        )
                      ),
                    ),
                    child: const Text(AskDialogText.confirmDeleteAsk)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> showConfirmDeleteAskDialog(
  BuildContext context,
  AppForm appForm
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmDeleteAskDialog(appForm: appForm);
    }
  );
}

class EditableAskHeader extends StatelessWidget {
  const EditableAskHeader({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p35),
      child: Column(
        children: [
          gapH35,
          VisibleOnTimelineLabel(
            isDeadlinePassed: ask.isDeadlinePassed,
            isOnTimeline: ask.isOnTimeline,
            isTargetMet: ask.isTargetMet,
          ),
          gapH15,
          IsTargetMetLabel(targetMetDateString: ask.formattedTargetMetDate,),
        ]
      ),
    );
  }
}

class VisibleOnTimelineLabel extends StatelessWidget {
  const VisibleOnTimelineLabel({
    required this.isDeadlinePassed,
    required this.isOnTimeline,
    required this.isTargetMet,
  });

  final bool isDeadlinePassed;
  final bool isOnTimeline;
  final bool isTargetMet;

  @override
  Widget build(BuildContext context) {
    var color = isOnTimeline ?
      AppThemes.positiveColor : Theme.of(context).colorScheme.onPrimaryFixed;

    var firstText = isOnTimeline ?
      AskDialogText.visibleOnTimeline : AskDialogText.notVisibleOnTimeline;

    var deadlineText = isDeadlinePassed ? " ${AskDialogText.reasonDeadlinePassed}" : "";
    var targetMetText = isTargetMet ? " ${AskDialogText.reasonTargetMet}" : "";
    var secondText = [targetMetText, deadlineText].firstWhere(
      (val) => val.isNotEmpty, orElse: () => "");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          isOnTimeline ? Icons.local_florist : Icons.visibility_off_rounded,
          size: AppIconSizes.s25,
          color: color,
        ),
        gapW10,
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(text: firstText),
                TextSpan(text: secondText)
              ]
            ),
          ),
        ),
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
            AskDialogText.targetMet : AskDialogText.targetNotMet,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          )
        )
      ],
    );
  }
}