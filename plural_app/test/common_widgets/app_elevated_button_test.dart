import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';

void main() {
  group("AppElevatedButton test", () {
    testWidgets("initial values", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppElevatedButton(
              callback: () {},
              icon: null,
              label: "",
              namedArguments: null,
              positionalArguments: null
            ),
          ),
        ));

      // Check Icon isn't rendererd and text == ""
      expect(find.byType(Icon), findsNothing);
      expect(find.text(""), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppElevatedButton(
              callback: () {},
              icon: Icons.palette,
              label: "Maakye waakye",
              namedArguments: null,
              positionalArguments: null
            ),
          ),
        ));

      // Check values properly rendered
      expect(find.byIcon(Icons.palette), findsOneWidget);
      expect(find.text("Maakye waakye"), findsOneWidget);
    });

    testWidgets("callback", (tester) async {
      final testList = [];
      const testStringA = "a";
      const testStringB = "b";

      void testFunc(List list, String arg1, {required String arg2}) {
        list.add(arg1);
        list.add(arg2);
      }

      // Check testList is empty
      expect(testList.isEmpty, true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppElevatedButton(
              callback: testFunc,
              icon: null,
              label: "",
              namedArguments: {#arg2: testStringA},
              positionalArguments: [testList, testStringB]
            ),
          ),
        ));

      // Press button (to call the callback)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check testList has testStringA, and testStringB
      expect(testList.isNotEmpty, true);
      expect(testList[0], testStringB);
      expect(testList[1], testStringA);
    });
  });
}