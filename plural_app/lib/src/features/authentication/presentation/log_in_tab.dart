import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';

// Authentication
import 'package:plural_app/src/features/authentication/data/forms.dart';
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class LogInTab extends StatelessWidget {
  const LogInTab({
    required this.appForm,
    this.database, // primarily for testing
    required this.formKey,
  });

  final AppForm appForm;
  final PocketBase? database;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          AppTextFormField(
            appForm: appForm,
            autofocus: true,
            fieldName: SignInField.usernameOrEmail,
            label: SignInPageText.email,
            maxLength: AppMaxLengths.max50,
            paddingTop: AppPaddings.p0,
            validator: validateUsernameOrEmail,
          ),
          LogInPasswordFormField(
            appForm: appForm,
            maxLength: AppMaxLengths.max64,
            paddingTop: AppPaddings.p0,
          ),
          gapH30,
          AppElevatedButton(
            callback: submitLogIn,
            label: SignInPageText.logIn,
            positionalArguments: [context, formKey, appForm],
            namedArguments: {#database: database},
          ),
        ],
      ),
    );
  }
}