import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Authentication
import 'package:plural_app/src/features/authentication/domain/forms.dart';
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';

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
            maxLength: FormValues.emailMaxLength,
            modelMap: logInMap,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
            validator: validateUsernameOrEmail,
          ),
          LogInPasswordFormField(
            maxLength: FormValues.passwordMaxLength,
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