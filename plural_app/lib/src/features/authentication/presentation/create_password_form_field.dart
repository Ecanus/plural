import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';

class CreatePasswordFormField extends StatefulWidget {
  const CreatePasswordFormField({
    super.key,
    this.maxLines = AppMaxLinesValues.max1,
    required this.modelMap,
    this.paddingBottom,
    this.paddingTop,
  });

  final int? maxLines;
  final Map modelMap;
  final double? paddingBottom;
  final double? paddingTop;

  @override
  State<CreatePasswordFormField> createState() => _CreatePasswordFormFieldState();
}

class _CreatePasswordFormFieldState extends State<CreatePasswordFormField> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late FocusNode _passwordFieldFocusNode;
  late ValueNotifier<String> _passwordRequirementNotifier;

  late double _paddingBottom;
  late double _paddingTop;
  late bool _isPasswordVisible;
  late bool _isConfirmPasswordVisible;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController.removeListener(_updatePasswordRequirementWidgets);
    _confirmPasswordController.dispose();

    _passwordFieldFocusNode.dispose();
    _passwordFieldFocusNode.removeListener(_rebuild);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _passwordController.text = "";
    _passwordController.addListener(_updatePasswordRequirementWidgets);
    _confirmPasswordController.text = "";

    _passwordFieldFocusNode = FocusNode();
    _passwordFieldFocusNode.addListener(_rebuild);

    _passwordRequirementNotifier = ValueNotifier<String>(_passwordController.text);

    _paddingBottom = widget.paddingBottom ?? AppPaddings.p20;
    _paddingTop = widget.paddingTop ?? AppPaddings.p20;
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
  }

  void _rebuild() {
    setState(() {});
  }

  // Password
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  bool _getPasswordVisibility() {
    return _isPasswordVisible;
  }

  void _updatePasswordRequirementWidgets() {
    _passwordRequirementNotifier.value = _passwordController.text;
  }

  // Confirm Password
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  bool _getConfirmPasswordVisibility() {
    return _isConfirmPasswordVisible;
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
            controller: _passwordController,
            decoration: InputDecoration(
              errorText: widget.modelMap[ModelMapKeys.errorTextKey],
              label: Text(Labels.password),
              suffixIcon: ShowHidePasswordButton(
                isPasswordVisible: _getPasswordVisibility,
                onPressed: _togglePasswordVisibility,
              ),
            ),
            focusNode: _passwordFieldFocusNode,
            inputFormatters: getInputFormatters(TextFieldType.text),
            maxLength: FormValues.passwordMaxLength,
            maxLines: widget.maxLines,
            obscureText: !_isPasswordVisible,
            onSaved: (value) => saveToMap(
              SignInField.password,
              widget.modelMap,
              value,
              formFieldType: FormFieldType.string,
            ),
            validator: (value) => validateNewPassword(value),
          ),
        ),
        AnimatedSize(
          duration: FormValues.passwordRequirementsRevealDuration,
          child: Container(
            height: _passwordFieldFocusNode.hasFocus ? null : 0.0,
            padding: EdgeInsets.only(
              bottom: AppPaddings.p25
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  PasswordRequirementText(
                    notifier: _passwordRequirementNotifier,
                    requirement: checkPasswordLength,
                    text: SignInStrings.passwordLength
                  ),
                  PasswordRequirementText(
                    notifier: _passwordRequirementNotifier,
                    requirement: checkHasLowercase,
                    text: SignInStrings.passwordLowercase
                  ),
                  PasswordRequirementText(
                    notifier: _passwordRequirementNotifier,
                    requirement: checkHasUppercase,
                    text: SignInStrings.passwordUppercase
                  ),
                  PasswordRequirementText(
                    notifier: _passwordRequirementNotifier,
                    requirement: checkHasNumber,
                    text: SignInStrings.passwordNumber
                  ),
                  PasswordRequirementText(
                    notifier: _passwordRequirementNotifier,
                    requirement: checkHasSpecialCharacter,
                    text: SignInStrings.passwordSpecial
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: _paddingTop,
            bottom: _paddingBottom,
          ),
          child: TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              errorText: widget.modelMap[ModelMapKeys.errorTextKey],
              label: Text(Labels.confirmPassword),
              suffixIcon: ShowHidePasswordButton(
                isPasswordVisible: _getConfirmPasswordVisibility,
                onPressed: _toggleConfirmPasswordVisibility,
              ),
            ),
            inputFormatters: getInputFormatters(TextFieldType.text),
            maxLength: FormValues.passwordMaxLength,
            maxLines: widget.maxLines,
            obscureText: !_isConfirmPasswordVisible,
            validator: (value) => validateConfirmNewPassword(
              value,
              _passwordController.text
            ),
          ),
        ),
      ],
    );
  }
}

/// Class observing the TextFormField for the new password.
/// Rebuilds the widget every time that the new password value changes.
class PasswordRequirementText extends StatelessWidget {
  const PasswordRequirementText({
    super.key,
    required this.notifier,
    required this.requirement,
    required this.text,
  });

  final ValueNotifier<String> notifier;
  final Function requirement;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (BuildContext context, String passwordValue, Widget? _) {
        final isValid = requirement(passwordValue);

        final isValidIcon = Icon(
          Icons.check,
          color: Colors.green
        );

        final isInvalidIcon = Icon(Icons.close);

        return Row(
          children: [
            isValid ? isValidIcon : isInvalidIcon,
            gapW5,
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isValid ? Colors.green : Colors.black
                )
              )
            ),
          ],
        );
      }
    );
  }
}