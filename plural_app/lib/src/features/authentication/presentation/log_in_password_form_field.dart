import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/common_classes/app_form.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Authentication
import 'package:plural_app/src/features/authentication/presentation/forgot_password_dialog.dart';

class LogInPasswordFormField extends StatefulWidget {
  const LogInPasswordFormField({
    super.key,
    required this.appForm,
    this.maxLength = AppMaxLengthValues.max20,
    this.maxLines = AppMaxLinesValues.max1,
    this.paddingBottom,
    this.paddingTop,
  });

  final AppForm appForm;
  final int maxLength;
  final int? maxLines;
  final double? paddingBottom;
  final double? paddingTop;

  @override
  State<LogInPasswordFormField> createState() => _LogInPasswordFormFieldState();
}

class _LogInPasswordFormFieldState extends State<LogInPasswordFormField> {
  final _controller = TextEditingController();

  late double _paddingTop;
  late bool _isPasswordVisible;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override void initState() {
    super.initState();

    _controller.text = "";

    _paddingTop = widget.paddingTop ?? AppPaddings.p20;
    _isPasswordVisible = false;
  }

  // Password
  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  bool getPasswordVisibility() {
    return _isPasswordVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: _paddingTop,
          ),
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              errorText: widget.appForm.getError(
                fieldName: UserField.password),
              label: Text(SignInLabels.password),
              suffixIcon: ShowHidePasswordButton(
                isPasswordVisible: getPasswordVisibility,
                onPressed: togglePasswordVisibility
              ),
            ),
            inputFormatters: getInputFormatters(TextFieldType.text),
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            obscureText: !_isPasswordVisible,
            onSaved: (value) => widget.appForm.save(
              fieldName: UserField.password,
              value: value,
            ),
            validator:(value) => validateTextFormField(value),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => createForgotPasswordDialog(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              overlayColor: Colors.transparent
            ),
            child: Text(SignInLabels.forgotPassword),
          ),
        ),
      ],
    );
  }
}