import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
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
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/forms.dart';
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createCreatableAskDialog(BuildContext context) {
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
  @override
  State<AskDialogCreateForm> createState() => _AskDialogCreateFormState();
}

class _AskDialogCreateFormState extends State<AskDialogCreateForm> {
  late AppForm _appForm;
  late AppState _appState;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appForm = AppForm.fromMap(Ask.emptyMap());
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); }
    );

    _appState = GetIt.instance<AppState>();

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
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
                    AppDatePickerFormField(
                      appForm: _appForm,
                      fieldName: AskField.deadlineDate,
                      label: AskDialogLabels.deadlineDate,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.targetSum,
                            formFieldType: FormFieldType.int,
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
                            label: AskDialogLabels.boon,
                            maxLength: AppMaxLengthValues.max4,
                            suffixIcon: Tooltip(
                              message: Tooltips.boon,
                              child: AppTooltipIcon(dark: false),
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
                            initialValue: _appState.currentUserSettings!.defaultCurrency,
                            label: AskDialogLabels.currency,
                          )
                        )
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.description,
                      label: AskDialogLabels.description,
                      maxLength: AppMaxLengthValues.max400,
                      maxLines: null,
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.instructions,
                      initialValue: _appState.currentUserSettings!.defaultInstructions,
                      label: AskDialogLabels.instructions,
                      maxLength: AppMaxLengthValues.max200,
                      maxLines: null,
                      suffixIcon: Tooltip(
                        message: Tooltips.instructions,
                        child: AppTooltipIcon(dark: false),
                      ),
                    ),
                    Visibility.maintain( // Hidden form field. Always saves type == monetary for now
                      visible: false,
                      child: AppTextFormField(
                        appForm: _appForm,
                        fieldName: AskField.type,
                        initialValue: AskType.monetary.name, // Hardcoded value for now
                        label: AskDialogLabels.type,
                      ),
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
            AppDialogFooterBufferSubmitButton(
              callback: submitCreate,
              positionalArguments: [context, _formKey, _appForm],
            ),
          ]
        ),
        AppDialogFooter(title: AppDialogTitles.createAsk)
      ],
    );
  }
}