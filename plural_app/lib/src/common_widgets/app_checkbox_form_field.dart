import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppCheckboxFormFieldFilled extends StatelessWidget {
  const AppCheckboxFormFieldFilled({
    super.key,
    required this.value,
    required this.text,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final bool value;
  final String text;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppPaddings.p20,
        bottom: AppPaddings.p20
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Checkbox(
            value: value,
            onChanged: null,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        ]
      ),
    );
  }
}