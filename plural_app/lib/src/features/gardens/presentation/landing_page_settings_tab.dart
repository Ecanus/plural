import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_tooltip_icon.dart';
import 'package:plural_app/src/common_widgets/delete_account_button.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/forms.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

class LandingPageSettingsTab extends StatefulWidget {
  @override
  State<LandingPageSettingsTab> createState() => _LandingPageSettingsTabState();
}

class _LandingPageSettingsTabState extends State<LandingPageSettingsTab> {
  late AppForm _userAppForm;
  late AppForm _userSettingsAppForm;
  late GlobalKey<FormState> _formKey;
  late AppUser _user;
  late AppUserSettings _userSettings;

  @override
  void initState() {
    super.initState();

    _user = GetIt.instance<AppState>().currentUser!;
    _userSettings = GetIt.instance<AppState>().currentUserSettings!;

    _formKey = GlobalKey<FormState>();

    // AppForms
    _userAppForm = AppForm.fromMap(_user.toMap());
    _userSettingsAppForm = AppForm.fromMap(_userSettings.toMap());
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppPaddings.p35),
              children: [
                AppCurrencyPickerFormField(
                  appForm: _userSettingsAppForm,
                  fieldName: UserSettingsField.defaultCurrency,
                  initialValue: _userSettings.defaultCurrency,
                  label: UserSettingsViewText.defaultCurrency,
                ),
                AppTextFormField(
                  appForm: _userSettingsAppForm,
                  fieldName: UserSettingsField.defaultInstructions,
                  initialValue: _userSettings.defaultInstructions,
                  label: UserSettingsViewText.defaultInstructions,
                  maxLength: AppMaxLengths.max200,
                  maxLines: null,
                  suffixIcon: Tooltip(
                        message: AskViewText.instructionsTooltip,
                        child: AppTooltipIcon(isDark: false),
                      ),
                ),
                gapH30,
                AppTextFormField(
                  appForm: _userAppForm,
                  fieldName: UserField.firstName,
                  initialValue: _user.firstName,
                  label: UserSettingsViewText.firstName,
                  maxLength: AppMaxLengths.max200,
                  maxLines: null,
                  paddingTop: AppPaddings.p0,
                ),
                AppTextFormField(
                  appForm: _userAppForm,
                  fieldName: UserField.lastName,
                  initialValue: _user.lastName,
                  label: UserSettingsViewText.lastName,
                  maxLength: AppMaxLengths.max200,
                  maxLines: null,
                  paddingTop: AppPaddings.p0,
                ),
                DeleteAccountButton(),
              ],
            ),
          ),
        ),
        gapH30,
        AppElevatedButton(
          callback: submitUpdateSettings,
          positionalArguments: [context, _formKey, _userAppForm, _userSettingsAppForm],
          namedArguments: {#currentRoute: Routes.landing},
          label: LandingPageText.saveChanges,
        ),
        gapH10,
        LogOutButton(),
      ],
    );
  }
}