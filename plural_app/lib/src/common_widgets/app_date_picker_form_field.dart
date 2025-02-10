import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/constants/app_sizes.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

class AppDatePickerFormField extends StatefulWidget {
  AppDatePickerFormField({
    required this.fieldName,
    this.initialValue,
    this.label = "",
    required this.modelMap,
  });

  final String fieldName;
  final DateTime? initialValue;
  final String label;
  final Map modelMap;

  @override
  State<AppDatePickerFormField> createState() => _AppDatePickerFormFieldState();
}

class _AppDatePickerFormFieldState extends State<AppDatePickerFormField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.text = widget.initialValue == null ?
      "" : DateFormat(Strings.dateformatYMMdd).format(widget.initialValue!);
  }

  void setControllerText(DateTime newDate) {
    setState(() {
      _controller.text = DateFormat(Strings.dateformatYMMdd).format(newDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => selectDate(context, _controller.text, setControllerText),
          icon: Icon(Icons.edit)
        ),
        gapW10,
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              label: Text(widget.label),
            ),
            enabled: false,
            onSaved: (value) => saveToMap(
              widget.fieldName,
              widget.modelMap,
              value,
            ),
            validator: (value) => validateDatePickerFormField(value),
          )
        ),
      ],
    );
  }
}

Future<void> selectDate(
  BuildContext context,
  String dateString,
  Function setTextCallback,
  ) async {
    var today = DateTime.now().toLocal();
    var dateThreshold = today.add(AppDateValues.datePickerThreshold);
    var initialDate = dateString == "" ? null : DateTime.parse(dateString).toLocal();

    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: dateThreshold);

    if (datePicked != null && datePicked != initialDate) {
      setTextCallback(datePicked);
    }
}