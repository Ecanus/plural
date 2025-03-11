import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_logo.dart';

void main() {
  group("AppLogo test", () {
    testWidgets("Image", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppLogo(),
          ),
        ));

      // Check Icon isn't rendererd and text == ""
      expect(find.byType(Image), findsOneWidget);
    });
  });
}