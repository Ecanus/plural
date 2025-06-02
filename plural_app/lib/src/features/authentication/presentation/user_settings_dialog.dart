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

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';

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
                gapH10,
                ExitGardenButton(),
              ],
            ),
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            AppDialogFooterBufferSubmitButton(
              callback: submitUpdateSettings,
              positionalArguments: [
                context,
                _formKey,
                _userAppForm,
                _userSettingsAppForm,
                Routes.garden]
            ),
          ]
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.aspect_ratio,
          leftNavCallback: _appDialogRouter.routeToAskDialogListView,
          leftTooltipMessage: AppDialogFooterText.navToAsks,
          rightDialogIcon: Icons.people_alt_rounded,
          rightNavCallback: _appDialogRouter.routeToUserDialogListView,
          rightTooltipMessage: AppDialogFooterText.navToUsers,
          title: AppDialogFooterText.settings
        )
      ],
    );
  }
}

class ExitGardenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50
      ),
      child: OutlinedButton(
        onPressed: () => showConfirmExitGardenDialog(context),
        style: ButtonStyle(
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: Theme.of(context).colorScheme.error
            )
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          ),
        ),
        child: Text(
          UserSettingsDialogText.exitGarden,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}

class ConfirmExitGardenDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p20,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c500,
          height: AppConstraints.c300,
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
                  UserSettingsDialogText.confirmExitGarden,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    UserSettingsDialogText.confirmExitGardenSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            gapH50,
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
                      UserSettingsDialogText.cancelConfirmExitGarden,
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
                      rerouteToLandingAndPrepareGardenExit(context);
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
                    child: const Text(UserSettingsDialogText.exitGarden)
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

Future<void> showConfirmExitGardenDialog(
  BuildContext context,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmExitGardenDialog();
    }
  );
}
