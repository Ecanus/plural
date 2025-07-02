import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("CurrentGardenDialogList test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter()); // for AppDialogNavFooter

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createCurrentGardenSettingsDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            ),
          ),
        )
      );

      // Check CurrentGardenDialogList not yet displayed
      expect(find.byType(CurrentGardenSettingsView), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(CurrentGardenSettingsView), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Tap ExitGardenButton (to open another dialog)
      await tester.ensureVisible(find.byType(ExitGardenButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ExitGardenButton));
      await tester.pumpAndSettle();

      // Check ConfirmExitGardenDialog has been created
      expect(find.byType(ConfirmExitGardenDialog), findsOneWidget);

      // Tap close dialog button
      await tester.tap(find.text(UserSettingsDialogText.cancelConfirmExitGarden));
      await tester.pumpAndSettle();

      // Check ConfirmExitGardenDialog has been removed
      expect(find.byType(ConfirmExitGardenDialog), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("ListedLandingPageTile", (tester) async {
      var testRouter = GoRouter(
        initialLocation: "/test_listed_landing_page_tile",
        routes: [
          GoRoute(
            path: Routes.landing,
            builder: (_, __) => SizedBox(
              child: Text("Test routing to Landing Page was successful."),
            )
          ),
          GoRoute(
            path: "/test_listed_landing_page_tile",
            builder: (_, __) => Scaffold(
            body: Builder(
                builder: (BuildContext context) {
                  return GoToLandingPageTile();
                }
              ),
            ),
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check routed text not rendered, widget is present, and tile label is rendered
      expect(find.text("Test routing to Landing Page was successful."), findsNothing);
      expect(find.text(GardenDialogText.goToLandingPageLabel), findsOneWidget);
      expect(find.byType(GoToLandingPageTile), findsOneWidget);

      // Tap on the ListTile
      await tester.tap(find.byType(GoToLandingPageTile));
      await tester.pumpAndSettle();

      // Check successful reroute (text should now appear)
      expect(find.text("Test routing to Landing Page was successful."), findsOneWidget);
    });
  });
}