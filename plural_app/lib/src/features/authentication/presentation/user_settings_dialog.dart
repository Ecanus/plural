import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';
import 'package:plural_app/src/features/authentication/domain/forms.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

Future createUserSettingsDialog(BuildContext context) async {
  final userSettings = GetIt.instance<AppState>().currentUserSettings!;

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: UserSettingsDialog(userSettings: userSettings),
        );
      }
    );
  }
}

class UserSettingsDialog extends StatefulWidget {
  const UserSettingsDialog({
    required this.userSettings,
  });

  final AppUserSettings userSettings;

  @override
  State<UserSettingsDialog> createState() => _UserSettingsDialogState();
}

class _UserSettingsDialogState extends State<UserSettingsDialog> {
  late AppForm _appForm;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appForm = AppForm.fromMap(widget.userSettings.toMap());
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

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
                    AppCurrencyPickerFormField(
                      appForm: _appForm,
                      fieldName: UserSettingsField.defaultCurrency,
                      initialValue: widget.userSettings.defaultCurrency,
                      label: UserSettingsDialogText.defaultCurrency,
                    ),
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: UserSettingsField.defaultInstructions,
                      initialValue: widget.userSettings.defaultInstructions,
                      label: UserSettingsDialogText.defaultInstructions,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                    ),
                    gapH30,
                    LogOutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            AppDialogFooterBufferSubmitButton(
              callback: submitUpdateSettings,
              positionalArguments: [context, _formKey, _appForm]
            ),
          ]
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.library_add,
          leftNavCallback: appDialogRouter.routeToAskDialogListView,
          leftTooltipMessage: AppDialogFooterText.navToAsks,
          rightDialogIcon: Icons.people_alt_rounded,
          rightNavCallback: appDialogRouter.routeToUserDialogListView,
          rightTooltipMessage: AppDialogFooterText.navToUsers,
          title: AppDialogFooterText.settings
        )
      ],
    );
  }
}

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50,
      ),
      child: OutlinedButton(
        onPressed: () => logout(context),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: Theme.of(context).colorScheme.primary
            )
          )
        ),
        child: const Text(SignInPageText.logOut)
      ),
    );
  }
}