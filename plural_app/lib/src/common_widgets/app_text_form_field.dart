import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/styles.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    required this.appForm,
    required this.fieldName,
    this.formFieldType = FormFieldType.string,
    this.hintText = "",
    this.initialValue = "",
    this.label = "",
    this.maxLength = AppMaxLengths.max20,
    this.maxLines = AppMaxLines.max1,
    this.paddingBottom,
    this.paddingTop,
    this.suffixIcon,
    this.textFieldType = TextFieldType.text,
    this.validator,
  });

  final AppForm appForm;
  final String fieldName;
  final FormFieldType formFieldType;
  final String hintText;
  final String initialValue;
  final String label;
  final int maxLength;
  final int? maxLines;
  final double? paddingBottom;
  final double? paddingTop;
  final Widget? suffixIcon;
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
    _validator = widget.validator ?? validateTextFormField;
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
        inputFormatters: getInputFormatters(
          widget.textFieldType,
          widget.maxLength
        ),
        maxLines: widget.maxLines,
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