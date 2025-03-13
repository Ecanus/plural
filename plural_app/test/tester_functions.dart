import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum GetBy {
  type,
  text
}
T get<T extends Widget>(
  WidgetTester tester, {
  GetBy getBy = GetBy.type,
  String text = "",
}) {
  switch (getBy) {
    case GetBy.type:
      return tester.firstWidget<T>(find.byType(T).first);
    case GetBy.text:
      return tester.firstWidget<T>(find.text(text).first);
  }
}

T getLast<T extends Widget>(WidgetTester tester) {
  return tester.firstWidget<T>(find.byType(T).last);
}

TextEditingController textFieldController(WidgetTester tester) {
  return get<TextField>(tester).controller!;
}