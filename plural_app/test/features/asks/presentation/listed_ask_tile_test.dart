import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../tester_functions.dart';

void main() {
  group("ListedAskTile test", () {
    testWidgets("shouldStrikethrough deadlineDate", (tester) async {
      final tc = TestContext()
                  ..ask.deadlineDate = DateTime.now().add(const Duration(days: -10))
                  ..ask.targetMetDate = null;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                ListedAskTile(
                  ask: tc.ask,
                ),
              ],
            ),
          ),
        ));

      // Check description correctly rendered
      var description = get<Text>(
        tester,
        getBy: GetBy.text,
        text: tc.ask.listTileDescription
      );
      expect(description.style!.color, AppThemes.colorScheme.onPrimaryFixed);
      expect(description.style!.decoration, TextDecoration.lineThrough);

      // Check subtitle correctly rendered
      var subtitle = get<Text>(
        tester,
        getBy: GetBy.text,
        text: "${AskDialogText.deadlineDueBy}: ${tc.ask.formattedDeadlineDate}",
      );
      expect(subtitle.style!.color, AppThemes.colorScheme.onPrimaryFixed);
      expect(subtitle.style!.decoration, TextDecoration.lineThrough);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("shouldStrikethrough targetMetDate", (tester) async {
      final tc = TestContext()
                  ..ask.deadlineDate = DateTime.now().add(const Duration(days: 10))
                  ..ask.targetMetDate = DateTime(2001, 1, 31);

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                ListedAskTile(
                  ask: tc.ask,
                ),
              ],
            ),
          ),
        ));

      // Check description correctly rendered
      var description = get<Text>(
        tester,
        getBy: GetBy.text,
        text: tc.ask.listTileDescription
      );
      expect(description.style!.color, AppThemes.colorScheme.onPrimaryFixed);
      expect(description.style!.decoration, TextDecoration.lineThrough);

      // Check subtitle correctly rendered
      var subtitle = get<Text>(
        tester,
        getBy: GetBy.text,
        text: "${AskDialogText.deadlineDueBy}: ${tc.ask.formattedDeadlineDate}",
      );
      expect(subtitle.style!.color, AppThemes.colorScheme.onPrimaryFixed);
      expect(subtitle.style!.decoration, TextDecoration.lineThrough);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("!shouldStrikethrough", (tester) async {
      final tc = TestContext()
                  ..ask.deadlineDate = DateTime.now().add(const Duration(days: 10))
                  ..ask.targetMetDate = null;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                ListedAskTile(
                  ask: tc.ask,
                ),
              ],
            ),
          ),
        ));

      // Check description correctly rendered
      var description = get<Text>(
        tester,
        getBy: GetBy.text,
        text: tc.ask.listTileDescription
      );
      expect(description.style!.color, AppThemes.colorScheme.onPrimary);
      expect(description.style!.decoration, null);

      // Check subtitle correctly rendered
      var subtitle = get<Text>(
        tester,
        getBy: GetBy.text,
        text: "${AskDialogText.deadlineDueBy}: ${tc.ask.formattedDeadlineDate}",
      );
      expect(subtitle.style!.color, AppThemes.colorScheme.onPrimary);
      expect(subtitle.style!.decoration, null);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("TileTrailing test", () {
    testWidgets("isOnTimeline", (tester) async {
      // isOnTimeline == true
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: TileTrailing(isOnTimeline: true,),
          ),
        ),
      );

      // Check CircleAvatar shows if isOnTimeline; check color is correct
      expect(find.byType(CircleAvatar), findsOneWidget);

      var icon = getLast<Icon>(tester);
      expect(icon.color, AppThemes.positiveColor);

      // isOnTimeline == false
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: TileTrailing(isOnTimeline: false,),
          ),
        ),
      );

      // Check CircleAvatar doesn't show if !isOnTimeline; check color is correct
      expect(find.byType(CircleAvatar), findsNothing);

      icon = getLast<Icon>(tester);
      expect(icon.color, AppThemes.colorScheme.onSecondary);
    });
  });
}