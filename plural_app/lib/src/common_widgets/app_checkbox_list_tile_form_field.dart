import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class AppCheckboxListTileFormField extends StatefulWidget {
  AppCheckboxListTileFormField({
    super.key,
    required this.appForm,
    required this.fieldName,
    required this.formFieldType,
    required this.text,
    required this.value,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final AppForm appForm;
  final String fieldName;
  final FormFieldType formFieldType;
  final String text;
  final bool value;

  final MainAxisAlignment mainAxisAlignment;

  @override
  State<AppCheckboxListTileFormField> createState() => _AppCheckboxListTileFormFieldState();
}

class _AppCheckboxListTileFormFieldState extends State<AppCheckboxListTileFormField> {
  final ValueNotifier<bool> _checkboxNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _checkboxNotifier.value = widget.value;
  }

  void onChanged(bool value) {
    _checkboxNotifier.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _checkboxNotifier,
      builder: (BuildContext context, bool checkboxValue, Widget? child) {
        return Container(
          constraints: BoxConstraints(maxWidth: AppWidths.w200),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            ),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: FormField<bool>(
              builder: (_) {
                return CheckboxListTile(
                  checkColor: Theme.of(context).colorScheme.primaryContainer,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  title: Text(
                    widget.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: checkboxValue,
                  onChanged: (bool? value) => onChanged(value!),
                );
              },
              onSaved: (_) => widget.appForm.save(
                fieldName: widget.fieldName,
                value: _checkboxNotifier.value,
                formFieldType: widget.formFieldType,
              ),
              validator: (_) => validateCheckboxFormField(_checkboxNotifier.value),
            ),
          ),
        );
      }
    );
  }
}