import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.fieldName,
    this.formFieldType = FormFieldType.string,
    this.hintText = "",
    this.isPassword = false,
    this.initialValue = "",
    this.label = "",
    this.maxLength = AppMaxLengthValues.max20,
    this.maxLines = AppMaxLinesValues.max1,
    required this.modelMap,
    this.paddingBottom,
    this.paddingTop,
    this.textFieldType = TextFieldType.text,
    this.validator,
  });

  final String fieldName;
  final FormFieldType formFieldType;
  final String hintText;
  final String initialValue;
  final bool isPassword;
  final String label;
  final int maxLength;
  final int? maxLines;
  final Map modelMap;
  final double? paddingBottom;
  final double? paddingTop;
  final TextFieldType textFieldType;
  final Function? validator;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  final _controller = TextEditingController();

  late double _paddingBottom;
  late double _paddingTop;
  late Function _validator;
  late bool _isPasswordVisible;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override void initState() {
    super.initState();

    _controller.text = widget.initialValue;

    _paddingBottom = widget.paddingBottom ?? AppPaddings.p20;
    _paddingTop = widget.paddingTop ?? AppPaddings.p20;
    _isPasswordVisible = false;
    _validator = widget.validator ?? validateTextFormField;
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
    return Container(
      padding: EdgeInsets.only(
        top: _paddingTop,
        bottom: _paddingBottom,
      ),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          errorText: widget.modelMap[ModelMapKeys.errorTextKey],
          hintText: widget.hintText,
          label: Text(widget.label),
          suffixIcon: widget.isPassword ?
            ShowHidePasswordButton(
              isPasswordVisible: getPasswordVisibility,
              onPressed: togglePasswordVisibility,
            ) : null,
        ),
        inputFormatters: getInputFormatters(widget.textFieldType),
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        obscureText: (widget.isPassword && !_isPasswordVisible),
        onSaved: (value) => saveToMap(
          widget.fieldName,
          widget.modelMap,
          value,
          formFieldType: widget.formFieldType,
        ),
        validator:(value) => _validator(value),
      ),
    );
  }
}

class AppTextFormFieldFilled extends StatelessWidget {
  const AppTextFormFieldFilled({
    this.label = "",
    this.maxLines = AppMaxLinesValues.max1,
    required this.value,
  });

  final String label;
  final int? maxLines;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppPaddings.p20,
        bottom: AppPaddings.p20
      ),
      child: TextFormField(
        enabled: false,
        initialValue: value,
        maxLines: maxLines,
        decoration: InputDecoration(
          label: Text(label),
        ),
      ),
    );
  }
}

class ShowHidePasswordButton extends StatelessWidget {
  const ShowHidePasswordButton({
    super.key,
    required this.isPasswordVisible,
    required this.onPressed,
  });

  final Function isPasswordVisible;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onPressed(),
      icon: Icon(
        isPasswordVisible()
        ? Icons.visibility
        : Icons.visibility_off_rounded
      )
    );
  }
}