import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/admin_examine_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/examine_ask_view.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../tester_functions.dart';

void main() {
  group("GardenTimelineTile", () {
    testWidgets("widgets", (tester) async {
      final ask = AskFactory();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: ask, index: 0, isAdminPage: true,)
              ],
            ),
          )
        )
      );

      // Check widgets render correctly
      expect(find.byType(TileExamineAskButton), findsOneWidget);
      expect(find.byType(TileBackground), findsOneWidget);
      expect(find.byType(TileForeground), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: ask, index: 1, isAdminPage: false,)
              ],
            ),
          )
        )
      );

      // Check widgets render correctly
      expect(find.byType(TileExamineAskButton), findsOneWidget);
      expect(find.byType(TileBackground), findsOneWidget);
      expect(find.byType(TileForeground), findsOneWidget);
    });

    testWidgets("TileContents", (tester) async {
      final ask = AskFactory();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                TileContents(
                  ask: ask,
                  hasHiddenContent: false,
                )
              ],
            ),
          )
        )
      );

      // Check text renders; check text color is onPrimary when hideContent == false
      var text = get<Text>(tester, getBy: GetBy.text, text: ask.truncatedDescription);
      expect(find.text(ask.truncatedDescription), findsOneWidget);
      expect(text.style!.color, AppThemes.colorScheme.onPrimary);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                TileContents(
                  ask: ask,
                  hasHiddenContent: true,
                )
              ],
            ),
          )
        )
      );

      // Check text renders; check text color is transparent when hideContent == true
      text = get<Text>(tester, getBy: GetBy.text, text: ask.truncatedDescription);
      expect(find.text(ask.truncatedDescription), findsOneWidget);
      expect(text.style!.color, Colors.transparent);
    });

    testWidgets("isAdminPage", (tester) async {
      final ask = AskFactory();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: ask, index: 0, isAdminPage: true,)
              ],
            ),
          )
        )
      );

      // Check no view  displayed
      expect(find.byType(AdminExamineAskView), findsNothing);
      expect(find.byType(ExamineAskView), findsNothing);

      await tester.tap(find.byType(TileExamineAskButton));
      await tester.pumpAndSettle();

      // Check only AdminExamineAskView shows
      expect(find.byType(AdminExamineAskView), findsOneWidget);
      expect(find.byType(ExamineAskView), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("isAdminPage false", (tester) async {
      final user = AppUserFactory();
      final ask = AskFactory();

      final appState = AppState.skipSubscribe()
        ..currentUser = user; // for ask.isSponsoredByCurrentUser check

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: ask, index: 0, isAdminPage: false,)
              ],
            ),
          )
        )
      );

      // Check no view  displayed
      expect(find.byType(AdminExamineAskView), findsNothing);
      expect(find.byType(ExamineAskView), findsNothing);

      await tester.tap(find.byType(TileExamineAskButton));
      await tester.pumpAndSettle();

      // Check only ExamineAskView shows
      expect(find.byType(AdminExamineAskView), findsNothing);
      expect(find.byType(ExamineAskView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}