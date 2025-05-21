import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/forms.dart';
import 'package:plural_app/src/features/authentication/presentation/create_password_form_field.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class SignUpTab extends StatelessWidget {
  const SignUpTab({
    required this.appForm,
    required this.formKey,
  });

  final AppForm appForm;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: AppPaddings.p50,
        left: AppPaddings.p50,
        right: AppPaddings.p50,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                appForm: appForm,
                autofocus: true,
                fieldName: UserField.firstName,
                label: SignInPageText.firstName,
                maxLength: AppMaxLengths.max50,
                paddingTop: AppPaddings.p0,
              ),
            ),
            gapW20,
            Expanded(
              child: AppTextFormField(
                appForm: appForm,
                fieldName: UserField.lastName,
                label: SignInPageText.lastName,
                maxLength: AppMaxLengths.max50,
                paddingTop: AppPaddings.p0,
              ),
            ),
          ],
        ),
        AppTextFormField(
          appForm: appForm,
          fieldName: UserField.email,
          label: SignInPageText.email,
          maxLength: AppMaxLengths.max50,
          paddingTop: AppPaddings.p0,
          validator: validateEmail,
        ),
        AppTextFormField(
          appForm: appForm,
          fieldName: UserField.username,
          label: SignInPageText.username,
          maxLength: AppMaxLengths.max50,
          paddingTop: AppPaddings.p0,
        ),
        CreatePasswordFormField(
          appForm: appForm,
        ),
        gapH30,
        AppElevatedButton(
          callback: submitSignUp,
          label: SignInPageText.signUp,
          positionalArguments: [context, formKey, appForm],
        ),
      ],
    );
  }
}