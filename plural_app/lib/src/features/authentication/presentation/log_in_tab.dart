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

class LogInTab extends StatelessWidget {
  const LogInTab({
    super.key,
    required this.formKey,
    required this.logInMap,
  });

  final GlobalKey<FormState> formKey;
  final Map logInMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          AppTextFormField(
            fieldName: SignInField.usernameOrEmail,
            label: Labels.email,
            maxLength: AppMaxLengthValues.max50,
            modelMap: logInMap,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
            validator: validateUsernameOrEmail,
          ),
          AppTextFormField(
            fieldName: SignInField.password,
            isPassword: true,
            label: Labels.password,
            maxLength: AppMaxLengthValues.max50,
            modelMap: logInMap,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
          ),
          gapH30,
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
            onPressed: () => submitLogIn(context, formKey, logInMap),
            style: IconButton.styleFrom(backgroundColor: Colors.black),
            tooltip: Strings.loginTooltip,
          ),
        ],
      ),
    );
  }
}