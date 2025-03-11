import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/styles.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class AppDatePickerFormField extends StatefulWidget {
  AppDatePickerFormField({
    required this.appForm,
    required this.fieldName,
    this.initialValue,
    this.label = "",
    this.paddingBottom,
    this.paddingTop,
  });

  final AppForm appForm;
  final String fieldName;
  final DateTime? initialValue;
  final String label;
  final double? paddingBottom;
  final double? paddingTop;

  @override
  State<AppDatePickerFormField> createState() => _AppDatePickerFormFieldState();
}

class _AppDatePickerFormFieldState extends State<AppDatePickerFormField> {
  final _controller = TextEditingController();

  late double _paddingBottom;
  late double _paddingTop;

  @override
  void initState() {
    super.initState();

    // TextEditingController
    _controller.text = widget.initialValue == null ?
      "" : DateFormat(Formats.dateYMMdd).format(widget.initialValue!);

    // Padding
    _paddingBottom = widget.paddingBottom ?? AppPaddings.p20;
    _paddingTop = widget.paddingTop ?? AppPaddings.p20;
  }

  void _setControllerText(DateTime newDate) {
    setState(() {
      _controller.text = DateFormat(Formats.dateYMMdd).format(newDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: _paddingTop,
        bottom: _paddingBottom,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: IconButton(
              onPressed: () => showDatePickerDialog(
                context, _controller.text, _setControllerText
              ),
              icon: const Icon(Icons.mode_edit_outlined)
            ),
          ),
          gapW10,
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: AppStyles.textFieldBorder,
                errorText: widget.appForm.getError(fieldName: widget.fieldName),
                label: Text(widget.label),
              ),
              enabled: false,
              onSaved: (value) => widget.appForm.save(
                fieldName: widget.fieldName,
                value: value,
              ),
              validator: (value) => validateDatePickerFormField(value),
            )
          ),
        ],
      ),
    );
  }
}

Future<void> showDatePickerDialog(
  BuildContext context,
  String dateString,
  Function setTextCallback,
  ) async {
    var today = DateTime.now().toLocal();
    var dateThreshold = today.add(AppDateValues.datePickerThreshold);
    var initialDate = dateString.isEmpty ? null : DateTime.parse(dateString).toLocal();

    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: dateThreshold);

    if (datePicked != null && datePicked != initialDate) {
      setTextCallback(datePicked);
    }
}