import 'package:flutter/material.dart' show TextSpan;
import 'package:test/test.dart';

// Common Functions
import 'package:plural_app/src/common_functions/markdown.dart';

void main() {
  group("markdown tests", () {
    test("stripHttpMarkdown", () {
      final text = "Testing URL markdown [here](https://fakeurl.com).";
      var inlineSpans = stripHttpMarkdown(text: text);

      final parsedText = inlineSpans.fold(
        "",
        (previous, current) {
          return "$previous${(current as TextSpan).text!}";
        }
      );

      expect(parsedText, "Testing URL markdown here.");
    });
  });
}