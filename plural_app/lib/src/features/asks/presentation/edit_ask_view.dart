import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
import 'package:plural_app/src/common_widgets/app_tooltip_icon.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/themes.dart';

// Ask
import 'package:plural_app/src/features/asks/data/forms.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/delete_ask_button.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

Future createEditAskDialog({
  required BuildContext context,
  required Ask ask
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        view: EditAskView(ask: ask)
      );
    }
  );
}

class EditAskView extends StatefulWidget {
  const EditAskView({
    required this.ask,
  });

  final Ask ask;

  @override
  State<EditAskView> createState() => _EditAskViewState();
}

class _EditAskViewState extends State<EditAskView> {
  late AppDialogViewRouter _appDialogViewRouter;
  late AppForm _appForm;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    _appForm = AppForm.fromMap(widget.ask.toMap());
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); },
      isAux: true,
    );

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditAskHeader(ask: widget.ask),
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
                      label: AskViewText.deadlineDate,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.targetSum,
                            formFieldType: FormFieldType.digitsOnly,
                            initialValue: widget.ask.targetSum.toString(),
                            label: AskViewText.targetSum,
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
                            label: AskViewText.boon,
                            maxLength: AppMaxLengths.max4,
                            suffixIcon: Tooltip(
                              message: AskViewText.tooltipBoon,
                              child: AppTooltipIcon(isDark: false),
                            ),
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
                            label: AskViewText.currency,
                          )
                        )
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.description,
                      initialValue: widget.ask.description,
                      label: AskViewText.description,
                      maxLength: AppMaxLengths.max400,
                      maxLines: null,
                      suffixIcon: Tooltip(
                        message: AskViewText.urlFormattingText,
                        child: AppTooltipIcon(isDark: false),
                      ),
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.instructions,
                      initialValue: widget.ask.instructions,
                      label: AskViewText.instructions,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                      suffixIcon: Tooltip(
                        message: AskViewText.instructionsTooltip,
                        child: AppTooltipIcon(isDark: false),
                      ),
                    ),
                    gapH30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppCheckboxListTileFormField(
                          appForm: _appForm,
                          fieldName: AskField.targetMetDate,
                          formFieldType: FormFieldType.datetimeNow,
                          text: AskViewText.targetMet,
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
                        label: AskViewText.type,
                      ),
                    ),
                    DeleteAskButton(askID: widget.ask.id),
                  ],
                ),
              ),
            ]
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              icon: Icons.arrow_back,
              message: AskViewText.goToListedAsks,
              onPressed: _appDialogViewRouter.routeToListedAsksView,
            ),
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

class EditAskHeader extends StatelessWidget {
  const EditAskHeader({
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
          IsOnTimelineLabel(isOnTimeline: ask.isOnTimeline),
          gapH15,
          IsDeadlinePassedLabel(
            isDeadlinePassed: ask.isDeadlinePassed,
            isTargetMet: ask.isTargetMet,
          ),
          ask.isDeadlinePassed ? gapH15 : SizedBox(),
          IsTargetMetLabel(isTargetMet: ask.formattedTargetMetDate.isNotEmpty),
        ]
      ),
    );
  }
}

class IsOnTimelineLabel extends StatelessWidget {
  const IsOnTimelineLabel({
    required this.isOnTimeline,
  });

  final bool isOnTimeline;

  @override
  Widget build(BuildContext context) {
    final color = isOnTimeline ?
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
          isOnTimeline ? AskViewText.visibleOnTimeline : AskViewText.notVisibleOnTimeline,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          )
        )
      ],
    );
  }
}

class IsDeadlinePassedLabel extends StatelessWidget {
  const IsDeadlinePassedLabel({
    required this.isDeadlinePassed,
    required this.isTargetMet,
  });

  final bool isDeadlinePassed;
  final bool isTargetMet;

  @override
  Widget build(BuildContext context) {
    final color = isTargetMet ?
      Theme.of(context).colorScheme.onPrimaryFixed
      : Theme.of(context).colorScheme.error;

    return isDeadlinePassed ?
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.event_busy,
            size: AppIconSizes.s25,
            color: color,
          ),
          gapW10,
          Text(
            AskViewText.deadlinePassed,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            )
          )
        ],
      )
      : SizedBox();
  }
}

class IsTargetMetLabel extends StatelessWidget {
  const IsTargetMetLabel({
    required this.isTargetMet,
  });

  final bool isTargetMet;

  @override
  Widget build(BuildContext context) {
    final color = isTargetMet ?
      AppThemes.positiveColor
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
            AskViewText.targetMet : AskViewText.targetNotMet,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          )
        )
      ],
    );
  }
}