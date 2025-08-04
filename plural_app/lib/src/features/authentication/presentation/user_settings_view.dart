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
import 'package:plural_app/src/features/authentication/domain/constants.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
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
          view: UserSettingsView(
            user: user,
            userSettings: userSettings
          ),
        );
      }
    );
  }
}

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({
    required this.user,
    required this.userSettings,
  });

  final AppUser user;
  final AppUserSettings userSettings;

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  late AppDialogViewRouter _appDialogViewRouter;
  late AppForm _userAppForm;
  late AppForm _userSettingsAppForm;
  late GlobalKey<FormState> _formKey;

  late int _divisions;
  late int _currentSliderValue;

  @override
  void initState() {
    super.initState();

    _userAppForm = AppForm.fromMap(widget.user.toMap());
    _userSettingsAppForm = AppForm.fromMap(widget.userSettings.toMap());

    _formKey = GlobalKey<FormState>();
    _appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    _divisions = (
      UserSettingsConstants.maxGardenTimelineDisplayCount -
      UserSettingsConstants.minGardenTimelineDisplayCount).toInt();
    _currentSliderValue = widget.userSettings.gardenTimelineDisplayCount;
  }

  void _updateGardenTimelineDisplayCount(double value) {
    setState(() {
      _currentSliderValue = value.toInt();
      _userSettingsAppForm.setValue(
        fieldName: UserSettingsField.gardenTimelineDisplayCount,
        value: _currentSliderValue);
    });
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
                   UserSettingsCategoryHeader(
                      text: UserSettingsViewText.defaultValuesHeader
                    ),
                    gapH20,
                    AppCurrencyPickerFormField(
                      appForm: _userSettingsAppForm,
                      fieldName: UserSettingsField.defaultCurrency,
                      initialValue: widget.userSettings.defaultCurrency,
                      label: UserSettingsViewText.defaultCurrency,
                    ),
                    AppTextFormField(
                      appForm: _userSettingsAppForm,
                      fieldName: UserSettingsField.defaultInstructions,
                      initialValue: widget.userSettings.defaultInstructions,
                      label: UserSettingsViewText.defaultInstructions,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                    ),
                    gapH10,
                    GardenTimelineDisplayCountHeader(sliderValue: _currentSliderValue),
                    gapH10,
                    Slider(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPaddings.p10,
                        vertical: AppPaddings.p10,
                      ),
                      divisions: _divisions,
                      label: "$_currentSliderValue",
                      min: UserSettingsConstants.minGardenTimelineDisplayCount,
                      max: UserSettingsConstants.maxGardenTimelineDisplayCount,
                      secondaryActiveColor: Theme.of(context).colorScheme.secondaryFixed,
                      secondaryTrackValue: UserSettingsConstants.maxGardenTimelineDisplayCount,
                      value: _currentSliderValue.toDouble(),
                      onChanged: (double value) => _updateGardenTimelineDisplayCount(value),
                    ),
                    gapH60,
                    UserSettingsCategoryHeader(
                      text: UserSettingsViewText.personalInformationHeader
                    ),
                    gapH20,
                    AppTextFormField(
                      appForm: _userAppForm,
                      fieldName: UserField.firstName,
                      initialValue: widget.user.firstName,
                      label: UserSettingsViewText.firstName,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                      paddingTop: AppPaddings.p0,
                    ),
                    AppTextFormField(
                      appForm: _userAppForm,
                      fieldName: UserField.lastName,
                      initialValue: widget.user.lastName,
                      label: UserSettingsViewText.lastName,
                      maxLength: AppMaxLengths.max200,
                      maxLines: null,
                      paddingTop: AppPaddings.p0,
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
              positionalArguments: [
                context, _formKey, _userAppForm, _userSettingsAppForm],
              namedArguments: {#currentRoute: Routes.garden}
            ),
          ]
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.add,
          leftNavCallback: _appDialogViewRouter.routeToCreateAskView,
          leftTooltipMessage: AppDialogFooterText.navToAsksView,
          rightDialogIcon: Icons.local_florist,
          rightNavCallback: _appDialogViewRouter.routeToCurrentGardenSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToCurrentGardenSettingsView,
          title: AppDialogFooterText.settings
        )
      ],
    );
  }
}

class UserSettingsCategoryHeader extends StatelessWidget {
  const UserSettingsCategoryHeader({
    this.color,
    required this.text,
  });

  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: color ?? Theme.of(context).colorScheme.primary,
            fontSize: AppFontSizes.s16,
            fontWeight: FontWeight.w400,
          )
        ),
      ],
    );
  }
}

class GardenTimelineDisplayCountHeader extends StatelessWidget {
  const GardenTimelineDisplayCountHeader({
    required this.sliderValue,
  });

  final int sliderValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400
                ),
                text: UserSettingsViewText.gardenTimelineDisplayCountHeaderStart
              ),
              TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700
                ),
                text: "$sliderValue "
              ),
              TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400
                ),
                text: UserSettingsViewText.gardenTimelineDisplayCountHeaderEnd
              )
            ]
          ),
        ),
      ],
    );
  }
}
