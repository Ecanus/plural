import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

void main() {
  group("AppSnackbars test", () {
    testWidgets("SnackBar message", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(height: 100.0, width: 100.0,),
                  onTap: () {
                    final snackBar = AppSnackbars.getSnackbar(
                      "Success Message",
                      showCloseIcon: true,
                      snackbarType: SnackbarType.success
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }
            ),
          ),
        ));

      // Check text not displayed (NOTE: trailing space needed)
      expect(find.text("Success Message "), findsNothing);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Check text displayed (NOTE: trailing space needed)
      expect(find.text("Success Message "), findsOneWidget);
    });

    testWidgets("SnackBar boldMessage", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(height: 100.0, width: 100.0,),
                  onTap: () {
                    final snackBar = AppSnackbars.getSnackbar(
                      "Error Message",
                      boldMessage: "and bold message!",
                      showCloseIcon: true,
                      snackbarType: SnackbarType.error
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }
            ),
          ),
        ));

      // Check text not dispalyed
      expect(find.text("Error Message and bold message!"), findsNothing);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Check text displayed
      expect(find.text("Error Message and bold message!"), findsOneWidget);
    });

    testWidgets("SnackBar showCloseIcon true", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(height: 100.0, width: 100.0,),
                  onTap: () {
                    final snackBar = AppSnackbars.getSnackbar(
                      "Success Message",
                      showCloseIcon: true,
                      snackbarType: SnackbarType.success
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }
            ),
          ),
        ));

      // Check close button not yet dispalyed
      expect(find.byType(IconButton), findsNothing);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Check close button displayed
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets("SnackBar showCloseIcon false", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(height: 100.0, width: 100.0,),
                  onTap: () {
                    final snackBar = AppSnackbars.getSnackbar(
                      "Error Message",
                      showCloseIcon: false,
                      snackbarType: SnackbarType.error
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }
            ),
          ),
        ));

      // Check close button not dispalyed
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(IconButton), findsNothing);

      // Tap GestureDetector (to open Snackbar)
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Check snackbar displayed; close button still not displayed
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(IconButton), findsNothing);
    });
  });
}