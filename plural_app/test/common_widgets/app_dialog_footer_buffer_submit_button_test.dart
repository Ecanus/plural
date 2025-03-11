import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';

void main() {
  group("AppDialogFooterBufferSubmitButton test", () {
    testWidgets("callback and arguments", (tester) async {
      final testList = [];
      const testStringA = "StringA";
      const testStringB = "StringB";

      void testFunc(List list, String arg1, {required String arg2}) {
        list.add(arg1);
        list.add(arg2);
      }

      // Check testList is empty
      expect(testList.isEmpty, true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogFooterBufferSubmitButton(
              callback: testFunc,
              namedArguments: {#arg2: testStringB},
              positionalArguments: [testList, testStringA],
            ),
          ),
        ));

      // Press button (to call the callback)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check testList has testStringA, and testStringB
      expect(testList.isNotEmpty, true);
      expect(testList[0], testStringA);
      expect(testList[1], testStringB);
    });
  });
}