import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/forms.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createUserSettingsDialog(BuildContext context) async {
  final user = GetIt.instance<AppState>().currentUser!;
  final userSettings = GetIt.instance<AppState>().currentUserSettings!;

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: UserSettingsList(
            user: user,
            userSettings: userSettings
          ),
        );
      }
    );
  }
}

class UserSettingsList extends StatefulWidget {
  const UserSettingsList({
    required this.user,
    required this.userSettings,
  });

  final AppUser user;
  final AppUserSettings userSettings;

  @override
  State<UserSettingsList> createState() => _UserSettingsListState();
}

class _UserSettingsListState extends State<UserSettingsList> {
  late AppDialogRouter _appDialogRouter;
  late AppForm _userAppForm;
  late AppForm _userSettingsAppForm;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _userAppForm = AppForm.fromMap(widget.user.toMap());
    _userSettingsAppForm = AppForm.fromMap(widget.userSettings.toMap());

    _formKey = GlobalKey<FormState>();
    _appDialogRouter = GetIt.instance<AppDialogRouter>();
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
                  initialValue: widget.userSettings.defaultCurrency,
                  label: UserSettingsDialogText.defaultCurrency,
                ),
                AppTextFormField(
                  appForm: _userSettingsAppForm,
                  fieldName: UserSettingsField.defaultInstructions,
                  initialValue: widget.userSettings.defaultInstructions,
                  label: UserSettingsDialogText.defaultInstructions,
                  maxLength: AppMaxLengths.max200,
                  maxLines: null,
                ),
                gapH30,
                AppTextFormField(
                  appForm: _userAppForm,
                  fieldName: UserField.firstName,
                  initialValue: widget.user.firstName,
                  label: UserSettingsDialogText.firstName,
                  maxLength: AppMaxLengths.max200,
                  maxLines: null,
                  paddingTop: AppPaddings.p0,
                ),
                AppTextFormField(
                  appForm: _userAppForm,
                  fieldName: UserField.lastName,
                  initialValue: widget.user.lastName,
                  label: UserSettingsDialogText.lastName,
                  maxLength: AppMaxLengths.max200,
                  maxLines: null,
                  paddingTop: AppPaddings.p0,
                ),
                gapH30,
                LogOutButton(),
              ],
            ),
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            AppDialogFooterBufferSubmitButton(
              callback: submitUpdateSettings,
              positionalArguments: [
                context, _formKey, _userAppForm, _userSettingsAppForm],
              namedArguments: {#currentRoute: Routes.garden}
            ),
          ]
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.add,
          leftNavCallback: _appDialogRouter.routeToCreatableAskDialogView,
          leftTooltipMessage: AppDialogFooterText.navToAsksDialog,
          rightDialogIcon: Icons.local_florist,
          rightNavCallback: _appDialogRouter.routeToCurrentGardenDialogView,
          rightTooltipMessage: AppDialogFooterText.navToGardenDialog,
          title: AppDialogFooterText.settings
        )
      ],
    );
  }
}
