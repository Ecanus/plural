import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_button.dart';
import 'package:plural_app/src/constants/text_themes.dart';

// Tests
import '../tester_functions.dart';

void main() {
  group("AppTextButton", () {
    testWidgets("initial values", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              callback: () {},
              fontSize: null,
              fontWeight: null,
              label: "",
              namedArguments: null,
              positionalArguments: null
            ),
          ),
        ));

      // Check initial default values
      final style1 = get<Text>(tester).style!;
      expect(find.text(""), findsOneWidget);
      expect(style1.fontSize, 13.0);
      expect(style1.fontWeight, fontWeightMedium);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              callback: () {},
              fontSize: 2.0,
              fontWeight: fontWeightRegular,
              label: "Afehyia pa",
              namedArguments: null,
              positionalArguments: null
            ),
          ),
        ));

      // Check passed values are set
      final style2 = get<Text>(tester).style!;
      expect(find.text("Afehyia pa"), findsOneWidget);
      expect(style2.fontSize, 2.0);
      expect(style2.fontWeight, fontWeightRegular);
    });

    testWidgets("callback", (tester) async {
      final testList = [];
      const test2 = 2;

      void testFunc(List list, int arg1, {required int arg2}) {
        list.add(arg1);
        list.add(arg2);
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              callback: testFunc,
              fontSize: null,
              fontWeight: null,
              label: "",
              namedArguments: {#arg2: test2},
              positionalArguments: [testList, test2]
            ),
          ),
        ));

      // Press button (to call the callback)
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Check testList has test2 in two positions
      expect(testList.isNotEmpty, true);
      expect(testList[0], test2);
      expect(testList[1], test2);
    });
  });
}