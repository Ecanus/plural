import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Functions
import 'package:plural_app/src/common_functions/input_formatters.dart';

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
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/forms.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createCreatableAskDialog(BuildContext context) async {
  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AskDialogCreateForm(),
        );
      }
    );
  }
}

class AskDialogCreateForm extends StatefulWidget {
  @override
  State<AskDialogCreateForm> createState() => _AskDialogCreateFormState();
}

class _AskDialogCreateFormState extends State<AskDialogCreateForm> {
  late AppDialogRouter _appDialogRouter;
  late AppForm _appForm;
  late AppState _appState;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appDialogRouter = GetIt.instance<AppDialogRouter>();
    _appState = GetIt.instance<AppState>();
    _formKey = GlobalKey<FormState>();

    _appForm = AppForm.fromMap(Ask.emptyMap());
    _appForm.setValue(fieldName: AskField.creator, value: _appState.currentUser!.id);
    _appForm.setValue(fieldName: AskField.garden, value: _appState.currentGarden!.id);
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); },
      isAux: true,
    );
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
                      label: AskDialogText.deadlineDate,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            fieldName: AskField.targetSum,
                            formFieldType: FormFieldType.digitsOnly,
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
                            label: AskDialogText.boon,
                            maxLength: AppMaxLengths.max4,
                            suffixIcon: Tooltip(
                              message: AskDialogText.tooltipBoon,
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
                            initialValue: _appState.currentUserSettings!.defaultCurrency,
                            label: AskDialogText.currency,
                          )
                        )
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.description,
                      label: AskDialogText.description,
                      maxLength: AppMaxLengths.max400,
                      maxLines: null,
                      suffixIcon: Tooltip(
                        message: AskDialogText.urlFormattingText,
                        child: AppTooltipIcon(isDark: false),
                      ),
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: AskField.instructions,
                      initialValue: _appState.currentUserSettings!.defaultInstructions,
                      label: AskDialogText.instructions,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                      suffixIcon: Tooltip(
                        message: AskDialogText.tooltipInstructions,
                        child: AppTooltipIcon(isDark: false),
                      ),
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
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: _appDialogRouter.routeToCurrentGardenDialogView,
          leftTooltipMessage: AppDialogFooterText.navToGardenDialog,
          rightDialogIcon: Icons.settings,
          rightNavCallback: _appDialogRouter.routeToUserSettingsDialogView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsDialog,
          title: AppDialogFooterText.createAsk
        )
      ],
    );
  }
}