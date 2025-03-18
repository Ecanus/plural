import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';

// Constants
import 'package:plural_app/src/constants/formats.dart';

void main() {
  group("GardenClock test", () {
    testWidgets("_displayedTime", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GardenClock(),
          ),
        )
      );

      final displayedTime = DateFormat(Formats.dateYMMdd).format(DateTime.now().toLocal());

      // Check text widget is rendered
      expect(find.byType(Text), findsOneWidget);
      expect(find.text(displayedTime), findsOneWidget);
    });
  });
}