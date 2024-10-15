import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppCheckboxFormField extends StatefulWidget {
  AppCheckboxFormField({
    super.key,
    required this.fieldName,
    required this.formFieldType,
    required this.modelMap,
    required this.text,
    required this.value,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final String fieldName;
  final FormFieldType formFieldType;
  final Map modelMap;
  final String text;
  final bool value;

  final MainAxisAlignment mainAxisAlignment;

  @override
  State<AppCheckboxFormField> createState() => _AppCheckboxFormFieldState();
}

class _AppCheckboxFormFieldState extends State<AppCheckboxFormField> {
  final ValueNotifier<bool> _checkboxNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _checkboxNotifier.value = widget.value;
  }

  void onChanged(bool value, FormFieldState<bool> state) {
    _checkboxNotifier.value = value;

    // didChange() needed to call parent form's onChanged()
    state.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _checkboxNotifier,
      builder: (BuildContext context, bool checkboxValue, Widget? child) {
        return Container(
          padding: EdgeInsets.only(
            top: AppPaddings.p20,
            bottom: AppPaddings.p20
          ),
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: [
              FormField<bool>(
                builder: (state) {
                  return Checkbox(
                    value: checkboxValue,
                    onChanged: (bool? value) => onChanged(value!, state),
                  );
                },
                onSaved: (_) => saveToMap(
                  widget.fieldName,
                  widget.modelMap,
                  _checkboxNotifier.value,
                  formFieldType: widget.formFieldType,
                ),
                validator: (_) => validateCheckboxFormField(_checkboxNotifier.value),
              ),
              Text(widget.text),
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
    this.mainAxisAlignment = MainAxisAlignment.start,
    required this.text,
    required this.value,
  });

  final MainAxisAlignment mainAxisAlignment;
  final String text;
  final bool value;

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