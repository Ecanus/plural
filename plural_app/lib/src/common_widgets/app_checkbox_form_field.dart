import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppCheckboxFormField extends StatelessWidget {
  AppCheckboxFormField({
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
    final ValueNotifier<bool> checkboxNotifier = ValueNotifier<bool>(value);

    return ValueListenableBuilder(
      valueListenable: checkboxNotifier,
      builder: (BuildContext context, bool checkboxValue, Widget? child) {
        return Container(
          padding: EdgeInsets.only(
            top: AppPaddings.p20,
            bottom: AppPaddings.p20
          ),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Checkbox(
                value: checkboxValue,
                onChanged: (bool? newCheckboxValue) {
                  checkboxNotifier.value = newCheckboxValue!;
                },
              ),
              Text(text),
            ]
          ),
        );
      }
    );
  }
}

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