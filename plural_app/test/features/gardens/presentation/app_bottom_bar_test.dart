import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/create_ask_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/app_bottom_bar.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AppBottomBar test", () {
    testWidgets("createCreatableAskDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(CreateAskView), findsNothing);

      // Tap IconButton with Icons.add (opens creatable ask dialog)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(CreateAskView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createUserSettingsDialog", (tester) async {
      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Check AppBottomBar is rendered; UserSettingsDialog not rendered
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(UserSettingsView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.settings (opens user settings dialog)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(UserSettingsView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createCurrentGardenDialog", (tester) async {
      final tc = TestContext();

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState() // for GoToAdminPageTile
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Check AppBottomBar is rendered; AskDialogList is not
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(CurrentGardenSettingsView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.local_florist (opens listed gardens dialog)
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      expect(find.byType(CurrentGardenSettingsView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}