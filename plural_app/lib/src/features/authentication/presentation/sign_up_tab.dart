import 'package:flutter/material.dart';

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
    required this.formKey,
    required this.signUpMap,
  });

  final GlobalKey<FormState> formKey;
  final Map signUpMap;

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
                fieldName: UserField.firstName,
                label: Labels.firstName,
                maxLength: AppMaxLengthValues.max50,
                modelMap: signUpMap,
                paddingBottom: AppPaddings.p5,
                paddingTop: AppPaddings.p5,
              ),
            ),
            gapW20,
            Expanded(
              child: AppTextFormField(
                fieldName: UserField.lastName,
                label: Labels.lastName,
                maxLength: AppMaxLengthValues.max50,
                modelMap: signUpMap,
                paddingBottom: AppPaddings.p5,
                paddingTop: AppPaddings.p5,
              ),
            ),
          ],
        ),
        AppTextFormField(
          fieldName: UserField.email,
          label: Labels.email,
          maxLength: AppMaxLengthValues.max50,
          modelMap: signUpMap,
          paddingBottom: AppPaddings.p5,
          paddingTop: AppPaddings.p5,
          validator: validateEmail,
        ),
        AppTextFormField(
          fieldName: UserField.username,
          label: Labels.username,
          maxLength: AppMaxLengthValues.max50,
          modelMap: signUpMap,
          paddingBottom: AppPaddings.p5,
          paddingTop: AppPaddings.p5,
        ),
        CreatePasswordFormField(
          maxLength: AppMaxLengthValues.max50,
          modelMap: signUpMap,
          paddingBottom: AppPaddings.p5,
          paddingTop: AppPaddings.p5,
        ),
        gapH30,
        UnconstrainedBox(
          child: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
            onPressed: () => submitSignUp(context, formKey, signUpMap),
            style: IconButton.styleFrom(backgroundColor: Colors.black),
            tooltip: Strings.signupTooltip,
          ),
        ),
      ],
    );
  }
}