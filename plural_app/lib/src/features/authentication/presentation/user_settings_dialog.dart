import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header_button.dart';
import 'package:plural_app/src/common_widgets/app_text_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';
import 'package:plural_app/src/features/authentication/domain/forms.dart';
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_settings_button.dart';

Future createUserSettingsDialog(BuildContext context) async {
  final authRepository = GetIt.instance<AuthRepository>();
  final userSettings = await authRepository.getCurrentUserSettings();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: UserSettingsDialog(userSettings: userSettings),
          viewTitle: Strings.settingsViewTitle,
        );
      }
    );
  }
}

class UserSettingsDialog extends StatefulWidget {
  const UserSettingsDialog({
    super.key,
    required this.userSettings,
  });

  final AppUserSettings userSettings;

  @override
  State<UserSettingsDialog> createState() => _UserSettingsDialogState();
}

class _UserSettingsDialogState extends State<UserSettingsDialog> {
  late GlobalKey<FormState> _formKey;
  late Map _userSettingsMap;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _userSettingsMap = widget.userSettings.toMap();
  }

  @override
  Widget build(BuildContext context) {
    final Widget submitFormButton = AppDialogHeaderButton(
      buttonNotifier: ValueNotifier<bool>(true),
      icon: Icon(Icons.mode_edit_outlined),
      label: Strings.updateLabel,
      onPressed: () => submitUpdate(_formKey, _userSettingsMap),
    );

    return Column(
      children: [
        AppDialogHeader(
          firstHeaderButton: CloseDialogButton(),
          secondHeaderButton: GardenSettingsButton(),
          thirdHeaderButton: submitFormButton,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Center(
                child: AppTextButton(
                  callback: logout,
                  label: SignInLabels.logOut,
                  positionalArguments: [context],
                )
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormFieldDeprecated(
                      fieldName: UserSettingsField.textSize,
                      formFieldType: FormFieldType.int,
                      initialValue: widget.userSettings.textSize.toString(),
                      label: Strings.userSettingsTextSizeLabel,
                      maxLength: AppMaxLengthValues.max1,
                      modelMap: _userSettingsMap,
                      textFieldType: TextFieldType.digitsOnly,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}