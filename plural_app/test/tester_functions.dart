import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Checkbox checkbox(WidgetTester tester) {
  return tester.firstWidget<Checkbox>(find.byType(Checkbox));
}

TextField textField(WidgetTester tester) {
    return tester.firstWidget<TextField>(find.byType(TextField));
  }

TextEditingController textFieldController(WidgetTester tester) {
  return textField(tester).controller!;
}