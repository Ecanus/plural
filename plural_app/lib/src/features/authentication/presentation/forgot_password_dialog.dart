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
      child: Container(
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints.expand(
          width: AppConstraints.c600,
          height: AppConstraints.c350,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15)
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(AppPaddings.p80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(Headers.enterEmail),
                AppTextFormField(
                  appForm: _appForm,
                  fieldName: UserField.email,
                  label: Labels.email,
                  maxLength: FormValues.emailMaxLength,
                  validator: validateEmail,
                ),
                ElevatedButton(
                  onPressed: () => submitForgotPassword(
                    context, _formKey, _appForm),
                  child: Text(Labels.sendEmail),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}