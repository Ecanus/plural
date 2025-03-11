import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

T get<T extends Widget>(WidgetTester tester) {
  return tester.firstWidget<T>(find.byType(T).first);
}

T getLast<T extends Widget>(WidgetTester tester) {
  return tester.firstWidget<T>(find.byType(T).last);
}

TextEditingController textFieldController(WidgetTester tester) {
  return get<TextField>(tester).controller!;
}