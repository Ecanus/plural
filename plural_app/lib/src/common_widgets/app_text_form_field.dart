import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.fieldName,
    this.formFieldType = FormFieldType.string,
    this.hintText = "",
    this.initialValue = "",
    this.label = "",
    this.maxLength = AppMaxLengthValues.max20,
    this.maxLines = AppMaxLinesValues.max1,
    required this.modelMap,
    this.textFieldType = TextFieldType.text,
  });

  final String fieldName;
  final FormFieldType formFieldType;
  final String hintText;
  final String initialValue;
  final String label;
  final int maxLength;
  final int? maxLines;
  final Map modelMap;
  final TextFieldType textFieldType;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override void initState() {
    super.initState();
    _controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppPaddings.p20,
        bottom: AppPaddings.p20
      ),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          label: Text(widget.label),
        ),
        inputFormatters: getInputFormatters(widget.textFieldType),
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        onSaved: (value) => saveToMap(
          widget.fieldName,
          widget.modelMap,
          value,
          formFieldType: widget.formFieldType,
        ),
        validator:(value) => validateTextFormField(value),
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