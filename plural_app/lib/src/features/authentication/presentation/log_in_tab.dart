import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/common_classes/app_form.dart';

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
    required this.appForm,
    required this.formKey,
  });

  final AppForm appForm;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          AppTextFormField(
            appForm: appForm,
            fieldName: SignInField.usernameOrEmail,
            label: Labels.email,
            maxLength: FormValues.emailMaxLength,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
            validator: validateUsernameOrEmail,
          ),
          LogInPasswordFormField(
            appForm: appForm,
            maxLength: FormValues.passwordMaxLength,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
          ),
          gapH30,
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
            onPressed: () => submitLogIn(context, formKey, appForm),
            style: IconButton.styleFrom(backgroundColor: Colors.black),
            tooltip: Strings.loginTooltip,
          ),
        ],
      ),
    );
  }
}