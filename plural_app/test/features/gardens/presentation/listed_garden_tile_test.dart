import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("ListedGardenTile test", () {
    testWidgets("ListedGardenTile", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentGarden = null;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ListedGardenTile(garden: tc.garden);
              }
            ),
          ),
        ));

      // Check title is rendered; appState.currentGarden is null
      expect(find.text(tc.garden.name), findsOneWidget);
      expect(appState.currentGarden, null);

      // Tap on the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Check appState.currentGarden has updated
      expect(appState.currentGarden, tc.garden);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("LandingPageListedGardenTile", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentGarden = null;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      var testRouter = GoRouter(
        initialLocation: "/test_landing_tile",
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => SizedBox()
          ),
          GoRoute(
            path: "/test_landing_tile",
            builder: (_, __) => Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return LandingPageListedGardenTile(garden: tc.garden);
              }
            ),
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check title is rendered; appState.currentGarden is null
      expect(find.text(tc.garden.name), findsOneWidget);
      expect(appState.currentGarden, null);

      // Tap on the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Check appState.currentGarden has updated
      expect(appState.currentGarden, tc.garden);
    });

    tearDown(() => GetIt.instance.reset());

  });
}