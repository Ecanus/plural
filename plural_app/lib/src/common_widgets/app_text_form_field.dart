import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.initialValue = "",
    this.hintText = "",
    this.maxLines = 1
  });

  final String initialValue;
  final String hintText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppPaddings.p20,
        bottom: AppPaddings.p20
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText
        ),
        initialValue: initialValue,
        maxLines: maxLines,
      ),
    );
  }
}

class AppTextFormFieldFilled extends StatelessWidget {
  const AppTextFormFieldFilled({
    required this.value,
    this.maxLines = 1
  });

  final String value;
  final int? maxLines;

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
        maxLines: maxLines
      ),
    );
  }
}