import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("GardenHeader test", () {
    testWidgets("garden name", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
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

      // Check text widget is rendered; GardenClock is rendered;
      // refresh button is rendered
      expect(find.text(tc.garden.name), findsOneWidget);
      expect(find.byType(GardenClock), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets("refresh", (tester) async {
      final tc = TestContext();

      final mockAppState = MockAppState();

      // AppState.currentGarden()
      when(
        () => mockAppState.currentGarden
      ).thenAnswer(
        (_) => tc.garden
      );
      // AppState.refresh()
      when(
        () => mockAppState.refreshTimelineAsks()
      ).thenAnswer(
        (_) => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: mockAppState,
            child: Scaffold(
              body: GardenHeader(),
            )
          )
        ));

      // Tap on the refresh button
      await tester.tap(find.byType(IconButton));
      tester.pumpAndSettle();

      verify(() => mockAppState.refreshTimelineAsks()).called(1);
    });

    testWidgets("isModView", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Scaffold(
              body: GardenHeader(isModView: true,),
            )
          )
        ));

      expect(find.byType(ModViewIcon), findsOneWidget);
    });
  });
}