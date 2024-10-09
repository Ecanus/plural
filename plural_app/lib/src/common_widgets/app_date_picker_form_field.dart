import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/constants/app_sizes.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

class AppDatePickerFormField extends StatefulWidget {
  AppDatePickerFormField({
    required this.initialValue,
  });

  final DateTime initialValue;

  @override
  State<AppDatePickerFormField> createState() => _AppDatePickerFormFieldState();
}

class _AppDatePickerFormFieldState extends State<AppDatePickerFormField> {
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = DateFormat(Strings.dateformatYMMdd).format(widget.initialValue);
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
            enabled: false
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
    var today = DateTime.now();
    var dateThreshold = today.add(AppDateValues.datePickerThreshold);
    var initialDate = DateTime.parse(dateString);

    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: dateThreshold);

    if (datePicked != null && datePicked != initialDate) {
      setTextCallback(datePicked);
    }
}