import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.hintText,
  });

  final String hintText;

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
      ),
    );
  }
}

class AppTextFormFieldFilled extends StatelessWidget {
  const AppTextFormFieldFilled({
    super.key,
    required this.value,
  });

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
        decoration: InputDecoration(
          hintText: value,
        ),
      ),
    );
  }
}