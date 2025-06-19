import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AskDialogList test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings; // for initialValue of AppCurrencyPickerFormField

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AskDialogList(listedAskTiles: [
                ListedAskTile(ask: tc.ask),
                ListedAskTile(ask: tc.ask),
                ListedAskTile(ask: tc.ask),
              ])
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.byType(AskDialogList), findsOneWidget);
      expect(find.byType(ListedAskTile), findsNWidgets(3));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Check AskDialogCreateForm not yet in view
      expect(find.byType(AskDialogCreateForm), findsNothing);

      // Tap RouteToCreateAskViewButton (to route to another form view)
      await tester.ensureVisible(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();

      // Check RouteToCreateAskViewButton has been created
      expect(find.byType(AskDialogCreateForm), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("empty", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings; // for initialValue of AppCurrencyPickerFormField

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AskDialogList(listedAskTiles: [])
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.byType(AskDialogList), findsOneWidget);
      expect(find.byType(EmptyListedAskTilesMessage), findsOneWidget);
      expect(find.byType(ListedAskTile), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Check AskDialogCreateForm not yet in view
      expect(find.byType(AskDialogCreateForm), findsNothing);

      // Tap RouteToCreateAskViewButton (to route to another form view)
      await tester.ensureVisible(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();

      // Check RouteToCreateAskViewButton has been created
      expect(find.byType(AskDialogCreateForm), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}