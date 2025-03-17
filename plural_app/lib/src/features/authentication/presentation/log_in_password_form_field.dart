import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_widgets/app_text_button.dart';
import 'package:plural_app/src/common_functions/form_validators.dart';
import 'package:plural_app/src/common_functions/input_formatters.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/styles.dart';

// Authentication
import 'package:plural_app/src/features/authentication/presentation/forgot_password_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class LogInPasswordFormField extends StatefulWidget {
  const LogInPasswordFormField({
    required this.appForm,
    this.maxLength = AppMaxLengths.max20,
    this.maxLines = AppMaxLines.max1,
    this.paddingTop = AppPaddings.p20,
  });

  final AppForm appForm;
  final int maxLength;
  final int maxLines;
  final double paddingTop;

  @override
  State<LogInPasswordFormField> createState() => _LogInPasswordFormFieldState();
}

class _LogInPasswordFormFieldState extends State<LogInPasswordFormField> {
  final _controller = TextEditingController();
  late bool _isPasswordVisible;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override void initState() {
    super.initState();

    _controller.text = "";
    _isPasswordVisible = false;
  }

  // Password
  bool _getPasswordVisibility() {
    return _isPasswordVisible;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: widget.paddingTop,
          ),
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              border: AppStyles.textFieldBorder,
              enabledBorder: AppStyles.textFieldBorder,
              errorText: widget.appForm.getError(
                fieldName: UserField.password
              ),
              floatingLabelStyle: AppStyles.floatingLabelStyle,
              focusedBorder: AppStyles.textFieldFocusedBorder,
              focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
              label: const Text(SignInPageText.password),
              suffixIcon: ShowHidePasswordButton(
                callback: _togglePasswordVisibility,
                isPasswordVisible: _getPasswordVisibility,
              ),
            ),
            inputFormatters: getInputFormatters(
              TextFieldType.text,
              widget.maxLength
            ),
            maxLines: widget.maxLines,
            obscureText: !_isPasswordVisible,
            onSaved: (value) => widget.appForm.save(
              fieldName: UserField.password,
              value: value,
            ),
            validator:(value) => validateText(value),
          ),
        ),
        gapH5,
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: AppPaddings.p2),
            child: AppTextButton(
              callback: createForgotPasswordDialog,
              positionalArguments: [context],
              label: SignInPageText.forgotPassword,
            ),
          ),
        ),
      ],
    );
  }
}