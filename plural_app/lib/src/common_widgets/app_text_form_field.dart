import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';
import 'package:plural_app/src/common_functions/input_formatters.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/styles.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    required this.appForm,
    this.autofocus = false,
    this.controller,
    this.enabled = true,
    required this.fieldName,
    this.formFieldType = FormFieldType.text,
    this.hintText = "",
    this.initialValue = "",
    this.label = "",
    this.maxLength = AppMaxLengths.max20,
    this.maxLines = AppMaxLines.max1,
    this.minLines,
    this.paddingBottom = AppPaddings.p20,
    this.paddingTop = AppPaddings.p20,
    this.suffixIcon,
    this.textFieldType = TextFieldType.text,
    this.validator,
  });

  final AppForm appForm;
  final bool autofocus;
  final TextEditingController? controller;
  final bool enabled;
  final String fieldName;
  final FormFieldType formFieldType;
  final String hintText;
  final String initialValue;
  final String label;
  final int maxLength;
  final int? maxLines;
  final int? minLines;
  final double paddingBottom;
  final double paddingTop;
  final Widget? suffixIcon;
  final TextFieldType textFieldType;
  final String? Function(String?)? validator;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late TextEditingController _controller;
  late String? Function(String?) _validator;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue;

    _validator = widget.validator ?? getValidator();
  }

  String? Function(String?) getValidator() {
    var formFieldTypeName = widget.formFieldType.name;
    var textFieldTypeName = widget.textFieldType.name;

    if (formFieldTypeName == "text" && textFieldTypeName == "text") {
      return validateText;
    } else if (formFieldTypeName == "digitsOnly" && textFieldTypeName == "digitsOnly") {
      return validateDigitsOnly;
    } else {
      return validateText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
      ),
      child: TextFormField(
        autofocus: widget.autofocus,
        controller: _controller,
        decoration: InputDecoration(
          border: AppStyles.textFieldBorder,
          enabledBorder: AppStyles.textFieldBorder,
          errorText: widget.appForm.getError(fieldName: widget.fieldName),
          floatingLabelStyle: AppStyles.floatingLabelStyle,
          focusedBorder: AppStyles.textFieldFocusedBorder,
          focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
          hintText: widget.hintText,
          label: Text(widget.label),
          suffixIcon: widget.suffixIcon,
        ),
        enabled: widget.enabled,
        inputFormatters: getInputFormatters(
          widget.textFieldType,
          widget.maxLength
        ),
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onSaved: (value) => widget.appForm.save(
          fieldName: widget.fieldName,
          value: value,
          formFieldType: widget.formFieldType,
        ),
        validator: (value) => _validator(value),
      ),
    );
  }
}