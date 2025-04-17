import 'package:flutter/gestures.dart';
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

bool findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan && visitor.text == text) {
    (visitor.recognizer as TapGestureRecognizer).onTap!();
    // Return false if successful match
    return false;
  }

  return true;
}

/// Used to parse through a list of InlineSpan in a SelectableText
/// and to tap on any string matching the given [text] value.
bool tapTextSpan(SelectableText selectableText, String text) {
  final isTapped = !selectableText.textSpan!.visitChildren(
    (visitor) => findTextAndTap(visitor, text),
  );

  return isTapped;
}