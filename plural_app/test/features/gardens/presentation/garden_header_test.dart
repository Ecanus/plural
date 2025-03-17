import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


// Asks
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("GardenClock test", () {
    testWidgets("garden name", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentGarden = tc.garden;

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Scaffold(
              body: GardenHeader(),
            )
          )
        ));

      // Check text widget is rendered; GardenClock is rendered
      expect(find.text(tc.garden.name), findsOneWidget);
      expect(find.byType(GardenClock), findsOneWidget);
    });
  });
}