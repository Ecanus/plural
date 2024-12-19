import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/common_classes/app_form.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/forms.dart';
import 'package:plural_app/src/features/authentication/presentation/create_password_form_field.dart';

class SignUpTab extends StatelessWidget {
  const SignUpTab({
    super.key,
    required this.appForm,
    required this.formKey,
  });

  final AppForm appForm;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: AppPaddings.p35,
        left: AppPaddings.p50,
        right: AppPaddings.p50,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                appForm: appForm,
                fieldName: UserField.firstName,
                label: SignInLabels.firstName,
                maxLength: AppMaxLengthValues.max50,
                paddingTop: AppPaddings.p0,
              ),
            ),
            gapW20,
            Expanded(
              child: AppTextFormField(
                appForm: appForm,
                fieldName: UserField.lastName,
                label: SignInLabels.lastName,
                maxLength: AppMaxLengthValues.max50,
                paddingTop: AppPaddings.p0,
              ),
            ),
          ],
        ),
        AppTextFormField(
          appForm: appForm,
          fieldName: UserField.email,
          label: SignInLabels.email,
          maxLength: AppMaxLengthValues.max50,
          paddingTop: AppPaddings.p0,
          validator: validateEmail,
        ),
        AppTextFormField(
          appForm: appForm,
          fieldName: UserField.username,
          label: SignInLabels.username,
          maxLength: AppMaxLengthValues.max50,
          paddingTop: AppPaddings.p0,
        ),
        CreatePasswordFormField(
          appForm: appForm,
          paddingTop: AppPaddings.p0,
        ),
        gapH30,
        UnconstrainedBox(
          child: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
            onPressed: () => submitSignUp(context, formKey, appForm),
            style: IconButton.styleFrom(backgroundColor: Colors.black),
            tooltip: Strings.signupTooltip,
          ),
        ),
      ],
    );
  }
}