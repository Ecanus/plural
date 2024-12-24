import 'package:flutter/material.dart';

// Common Class
import 'package:plural_app/src/common_classes/app_form.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';
import 'package:plural_app/src/common_widgets/app_icons.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/styles.dart';
import 'package:plural_app/src/constants/themes.dart';

class CreatePasswordFormField extends StatefulWidget {
  const CreatePasswordFormField({
    super.key,
    this.maxLines = AppMaxLinesValues.max1,
    required this.appForm,
    this.paddingBottom,
    this.paddingTop,
  });

  final int? maxLines;
  final AppForm appForm;
  final double? paddingBottom;
  final double? paddingTop;

  @override
  State<CreatePasswordFormField> createState() => _CreatePasswordFormFieldState();
}

class _CreatePasswordFormFieldState extends State<CreatePasswordFormField> {
  final String _passwordFieldName = UserField.password;
  final String _passwordConfirmFieldName = UserField.passwordConfirm;

  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  late FocusNode _passwordFieldFocusNode;
  late FocusNode _passwordConfirmFieldFocusNode;
  late ValueNotifier<Map> _passwordValuesNotifier;

  late double _paddingTop;
  late bool _isPasswordVisible;
  late bool _isPasswordConfirmVisible;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController.removeListener(_updatePasswordValuesNotifier);
    _passwordConfirmController.dispose();

    _passwordFieldFocusNode.dispose();
    _passwordFieldFocusNode.removeListener(_rebuild);
    _passwordConfirmFieldFocusNode.dispose();
    _passwordConfirmFieldFocusNode.removeListener(_rebuild);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _passwordController.text = "";
    _passwordController.addListener(_updatePasswordValuesNotifier);
    _passwordConfirmController.text = "";
    _passwordConfirmController.addListener(_updatePasswordValuesNotifier);

    _passwordFieldFocusNode = FocusNode();
    _passwordFieldFocusNode.addListener(_rebuild);

    _passwordConfirmFieldFocusNode = FocusNode();
    _passwordConfirmFieldFocusNode.addListener(_rebuild);

    Map passwordValues = {
      UserField.password: _passwordController.text,
      UserField.passwordConfirm: _passwordConfirmController.text
    };

    _passwordValuesNotifier = ValueNotifier<Map>(passwordValues);

    _paddingTop = widget.paddingTop ?? AppPaddings.p20;
    _isPasswordVisible = false;
    _isPasswordConfirmVisible = false;
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

  void _updatePasswordValuesNotifier() {
    _passwordValuesNotifier.value = {
      UserField.password: _passwordController.text,
      UserField.passwordConfirm: _passwordConfirmController.text
    };
  }

  // Confirm Password
  void _togglePasswordConfirmVisibility() {
    setState(() {
      _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
    });
  }

  bool _getPasswordConfirmVisibility() {
    return _isPasswordConfirmVisible;
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
              border: AppStyles.textFieldBorder,
              enabledBorder: AppStyles.textFieldBorder,
              errorText: widget.appForm.getError(
                fieldName: _passwordFieldName
              ),
              floatingLabelStyle: AppStyles.floatingLabelStyle,
              focusedBorder: AppStyles.textFieldFocusedBorder,
              focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
              label: Text(SignInLabels.password),
              suffixIcon: ShowHidePasswordButton(
                isPasswordVisible: _getPasswordVisibility,
                onPressed: _togglePasswordVisibility,
              ),
            ),
            focusNode: _passwordFieldFocusNode,
            inputFormatters: getInputFormatters(
              TextFieldType.text,
              FormValues.passwordMaxLength
            ),
            maxLines: widget.maxLines,
            obscureText: !_isPasswordVisible,
            onSaved: (value) => widget.appForm.save(
              fieldName: _passwordFieldName,
              value: value,
            ),
            validator: (value) => validateNewPassword(value),
          ),
        ),
        AnimatedSize(
          duration: FormValues.passwordTextRowRevealDuration,
          child: Container(
            height: _passwordFieldFocusNode.hasFocus ? null : 0.0,
            padding: EdgeInsets.only(
              top: AppPaddings.p5,
              bottom: AppPaddings.p25
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    requirement: checkPasswordLength,
                    text: SignInMessages.passwordLength
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    requirement: checkHasLowercase,
                    text: SignInMessages.passwordLowercase
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    requirement: checkHasUppercase,
                    text: SignInMessages.passwordUppercase
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    requirement: checkHasNumber,
                    text: SignInMessages.passwordNumber
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    requirement: checkHasSpecialCharacter,
                    text: SignInMessages.passwordSpecial
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: AppPaddings.p20,
          ),
          child: TextFormField(
            controller: _passwordConfirmController,
            decoration: InputDecoration(
              border: AppStyles.textFieldBorder,
              enabledBorder: AppStyles.textFieldBorder,
              errorText: widget.appForm.getError(
                fieldName: _passwordConfirmFieldName),
              floatingLabelStyle: AppStyles.floatingLabelStyle,
              focusedBorder: AppStyles.textFieldFocusedBorder,
              focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
              label: Text(SignInLabels.passwordConfirm),
              suffixIcon: ShowHidePasswordButton(
                isPasswordVisible: _getPasswordConfirmVisibility,
                onPressed: _togglePasswordConfirmVisibility,
              ),
            ),
            focusNode: _passwordConfirmFieldFocusNode,
            inputFormatters: getInputFormatters(
              TextFieldType.text,
              FormValues.passwordMaxLength
            ),
            maxLines: widget.maxLines,
            obscureText: !_isPasswordConfirmVisible,
            onSaved: (value) => widget.appForm.save(
              fieldName: _passwordConfirmFieldName,
              value: value,
            ),
            validator: (value) => validateConfirmNewPassword(
              value,
              _passwordController.text
            ),
          ),
        ),
        AnimatedSize(
          duration: FormValues.passwordTextRowRevealDuration,
          child: Container(
            height: _passwordConfirmFieldFocusNode.hasFocus ? null : 0.0,
            padding: EdgeInsets.only(
              top: AppPaddings.p5,
              bottom: AppPaddings.p25
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: PasswordsMatchText(
                    notifier: _passwordValuesNotifier,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PasswordRequirementText extends StatelessWidget {
  const PasswordRequirementText({
    super.key,
    required this.notifier,
    required this.requirement,
    required this.text,
  });

  final ValueNotifier<Map> notifier;
  final Function requirement;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (BuildContext context, Map passwordValues, Widget? _) {
        final isValid = requirement(passwordValues[UserField.password]);

        return PasswordTextRow(
          isValid: isValid,
          isValidText: text
        );
      }
    );
  }
}

class PasswordsMatchText extends StatelessWidget {
  const PasswordsMatchText({
    super.key,
    required this.notifier,
  });

  final ValueNotifier<Map> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (BuildContext context, Map passwordValues, Widget? _) {
        final isValid = checkPasswordsMatch(
          passwordValues[UserField.password],
          passwordValues[UserField.passwordConfirm]
        );

        return PasswordTextRow(
          isValid: isValid,
          isInvalidText: ErrorMessages.passwordMismatch,
          isValidText: SignInMessages.passwordMatch
        );
      });
  }
}

class PasswordTextRow extends StatelessWidget {
  const PasswordTextRow({
    super.key,
    this.isInvalidText,
    required this.isValid,
    required this.isValidText,
  });

  final String? isInvalidText;
  final bool isValid;
  final String isValidText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isValid ? AppIcons.isValid : AppIcons.isInvalid,
        gapW5,
        Expanded(
          child: Text(
            isValid ? isValidText : (isInvalidText ?? isValidText),
            style: TextStyle(
              color: isValid ?
                AppThemes.successColor
                : Theme.of(context).colorScheme.onPrimary
            )
          ),
        ),
      ]
    );
  }
}