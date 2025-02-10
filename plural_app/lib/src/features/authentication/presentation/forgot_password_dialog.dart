import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Authentication
import 'package:plural_app/src/features/authentication/domain/forms.dart';

Future createForgotPasswordDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ForgotPasswordDialog();
    });
}

class ForgotPasswordDialog extends StatefulWidget {
  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late GlobalKey<FormState> _formKey;
  late AppForm _appForm;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _appForm = AppForm();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c500,
              height: AppConstraints.c400,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppBorderRadii.r15),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppPaddings.p40,
                  left: AppPaddings.p40,
                  right: AppPaddings.p40
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Headers.enterEmail,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    gapH20,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(SignInInstructions.forgotPassword),
                    ),
                    gapH40,
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: UserField.email,
                      label: SignInLabels.email,
                      maxLength: FormValues.emailMaxLength,
                      validator: validateEmail,
                    ),
                    AppElevatedButton(
                      callback: submitForgotPassword,
                      label: SignInLabels.sendEmail,
                      positionalArguments: [context, _formKey, _appForm],
                    )
                  ],
                ),
              ),
            ),
          ),
          gapH30,
          CloseDialogButton()
        ],
      ),
    );
  }
}