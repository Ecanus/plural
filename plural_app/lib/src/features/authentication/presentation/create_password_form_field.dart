import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';
import 'package:plural_app/src/common_functions/input_formatters.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/styles.dart';
import 'package:plural_app/src/constants/themes.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class CreatePasswordFormField extends StatefulWidget {
  const CreatePasswordFormField({
    required this.appForm,
    this.maxLines = AppMaxLines.max1,
    this.paddingTop = AppPaddings.p20,
  });

  final AppForm appForm;
  final int maxLines;
  final double paddingTop;

  @override
  State<CreatePasswordFormField> createState() => _CreatePasswordFormFieldState();
}

class _CreatePasswordFormFieldState extends State<CreatePasswordFormField> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  final String _passwordFieldName = UserField.password;
  final String _passwordConfirmFieldName = UserField.passwordConfirm;

  late FocusNode _passwordFieldFocusNode;
  late FocusNode _passwordConfirmFieldFocusNode;
  late ValueNotifier<Map> _passwordValuesNotifier;

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
            top: widget.paddingTop,
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
              label: const Text(SignInPageText.password),
              suffixIcon: ShowHidePasswordButton(
                callback: _togglePasswordVisibility,
                isPasswordVisible: _getPasswordVisibility,
              ),
            ),
            focusNode: _passwordFieldFocusNode,
            inputFormatters: getInputFormatters(
              TextFieldType.text,
              AppMaxLengths.max64
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
        Container(
          padding: EdgeInsets.only(
            top: widget.paddingTop,
          ),
          child: TextFormField(
            controller: _passwordConfirmController,
            decoration: InputDecoration(
              border: AppStyles.textFieldBorder,
              enabledBorder: AppStyles.textFieldBorder,
              errorText: widget.appForm.getError(
                fieldName: _passwordConfirmFieldName
              ),
              floatingLabelStyle: AppStyles.floatingLabelStyle,
              focusedBorder: AppStyles.textFieldFocusedBorder,
              focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
              label: const Text(SignInPageText.passwordConfirm),
              suffixIcon: ShowHidePasswordButton(
                callback: _togglePasswordConfirmVisibility,
                isPasswordVisible: _getPasswordConfirmVisibility,
              ),
            ),
            focusNode: _passwordConfirmFieldFocusNode,
            inputFormatters: getInputFormatters(
              TextFieldType.text,
              AppMaxLengths.max64
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
          duration: AppDurations.ms125,
          child: Container(
            height: _passwordConfirmFieldFocusNode.hasFocus ? null : 0.0,
            padding: const EdgeInsets.only(
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
        ),
        AnimatedSize(
          duration: AppDurations.ms125,
          child: Container(
            height: _passwordFieldFocusNode.hasFocus ? null : 0.0,
            padding: const EdgeInsets.only(
              top: AppPaddings.p15,
              bottom: AppPaddings.p25
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    validationFunction: checkPasswordLength,
                    text: SignInPageText.passwordLength
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    validationFunction: checkHasLowercase,
                    text: SignInPageText.passwordLowercase
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    validationFunction: checkHasUppercase,
                    text: SignInPageText.passwordUppercase
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    validationFunction: checkHasNumber,
                    text: SignInPageText.passwordNumber
                  ),
                  PasswordRequirementText(
                    notifier: _passwordValuesNotifier,
                    validationFunction: checkHasSpecialCharacter,
                    text: SignInPageText.passwordSpecial
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordRequirementText extends StatelessWidget {
  const PasswordRequirementText({
    required this.notifier,
    required this.validationFunction,
    required this.text,
  });

  final ValueNotifier<Map> notifier;
  final bool Function(String) validationFunction;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (BuildContext context, Map passwordValues, Widget? _) {
        final isValid = validationFunction(passwordValues[UserField.password]);

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
          isInvalidText: SignInPageText.passwordMismatch,
          isValidText: SignInPageText.passwordMatch
        );
      });
  }
}

class PasswordTextRow extends StatelessWidget {
  const PasswordTextRow({
    this.isInvalidText,
    required this.isValid,
    required this.isValidText,
  });

  final String? isInvalidText;
  final bool isValid;
  final String isValidText;

  @override
  Widget build(BuildContext context) {
    Icon isValidIcon = Icon(
      Icons.check,
      color: AppThemes.successColor
    );

    Icon isInvalidIcon = Icon(
      Icons.close,
      color: AppThemes.colorScheme.onPrimary,
    );

    return Row(
      children: [
        isValid ? isValidIcon : isInvalidIcon,
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