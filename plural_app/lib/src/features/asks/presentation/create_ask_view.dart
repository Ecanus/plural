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

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

Future createCreateAskDialog(BuildContext context) async {
  final userGardenRecord = GetIt.instance<AppState>().currentUserGardenRecord;

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: CreateAskView(hasReadDoDocument: userGardenRecord!.hasReadDoDocument,),
        );
      }
    );
  }
}

class CreateAskView extends StatefulWidget {
  const CreateAskView({
    required this.hasReadDoDocument,
  });

  final bool hasReadDoDocument;

  @override
  State<CreateAskView> createState() => _CreateAskViewState();
}

class _CreateAskViewState extends State<CreateAskView> {
  late AppDialogViewRouter _appDialogViewRouter;
  late AppForm _appForm;
  late AppState _appState;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();
    _appState = GetIt.instance<AppState>();
    _formKey = GlobalKey<FormState>();

    _appForm = AppForm.fromMap(Ask.emptyMap());
    _appForm.setValue(fieldName: AskField.creator, value: _appState.currentUserID!);
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
        CreateAskHeader(
          hasReadDoDocument: widget.hasReadDoDocument,
          routeToExamineDoDocumentViewCallback:
            _appDialogViewRouter.routeToExamineDoDocumentView,
        ),
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
                      enabled: widget.hasReadDoDocument,
                      fieldName: AskField.deadlineDate,
                      label: AskViewText.deadlineDate,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            enabled: widget.hasReadDoDocument,
                            fieldName: AskField.targetSum,
                            formFieldType: FormFieldType.digitsOnly,
                            label: AskViewText.targetSum,
                            maxLength: AppMaxLengths.max4,
                            textFieldType: TextFieldType.digitsOnly,
                          ),
                        ),
                        gapW20,
                        Expanded(
                          child: AppTextFormField(
                            appForm: _appForm,
                            enabled: widget.hasReadDoDocument,
                            fieldName: AskField.boon,
                            formFieldType: FormFieldType.digitsOnly,
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
                            enabled: widget.hasReadDoDocument,
                            fieldName: AskField.currency,
                            initialValue: _appState.currentUserSettings!.defaultCurrency,
                            label: AskViewText.currency,
                          )
                        )
                      ],
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      enabled: widget.hasReadDoDocument,
                      fieldName: AskField.description,
                      formFieldType: FormFieldType.blankable,
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
                      enabled: widget.hasReadDoDocument,
                      fieldName: AskField.instructions,
                      initialValue: _appState.currentUserSettings!.defaultInstructions,
                      label: AskViewText.instructions,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                      suffixIcon: Tooltip(
                        message: AskViewText.instructionsTooltip,
                        child: AppTooltipIcon(isDark: false),
                      ),
                    ),
                    Visibility.maintain( // Hidden form field. Always saves type == monetary for now
                      visible: false,
                      child: AppTextFormField(
                        appForm: _appForm,
                        enabled: widget.hasReadDoDocument,
                        fieldName: AskField.type,
                        initialValue: AskType.monetary.name, // Hardcoded value for now
                        label: AskViewText.type,
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
            RouteToViewButton(
              callback: _appDialogViewRouter.routeToListedAsksView,
              icon: Icons.toc_rounded,
              message: AskViewText.goToListedAsks,
            ),
            AppDialogFooterBufferSubmitButton(
              callback: submitCreate,
              enabled: widget.hasReadDoDocument,
              positionalArguments: [context, _formKey, _appForm],
            ),
            RouteToViewButton(
              callback: _appDialogViewRouter.routeToSponsoredAsksView,
              icon: Icons.volunteer_activism,
              message: AskViewText.goToSponsoredAsks,
            ),
          ]
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: _appDialogViewRouter.routeToCurrentGardenSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToCurrentGardenSettingsView,
          rightDialogIcon: Icons.settings,
          rightNavCallback: _appDialogViewRouter.routeToUserSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsView,
          title: AppDialogFooterText.createAsk
        )
      ],
    );
  }
}

class CreateAskHeader extends StatelessWidget {
  const CreateAskHeader({
    required this.hasReadDoDocument,
    required this.routeToExamineDoDocumentViewCallback,
  });

  final bool hasReadDoDocument;
  final void Function() routeToExamineDoDocumentViewCallback;

  @override
  Widget build(BuildContext context) {
    return hasReadDoDocument ?
      SizedBox() :
      Padding(
        padding: const EdgeInsets.only(
          top: AppPaddings.p50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                AskViewText.readDoDocumentStart,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () => routeToExamineDoDocumentViewCallback(),
              child: Text(AskViewText.doDocument),
            ),
            Flexible(
              child: Text(
                AskViewText.readDoDocumentEnd,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
  }
}