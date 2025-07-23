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
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../tester_functions.dart';

void main() {
  group("ListedAskTile", () {
    testWidgets("shouldStrikethrough deadlineDate", (tester) async {
      final tc = TestContext()
                  ..ask.deadlineDate = DateTime.now().add(const Duration(days: -10))
                  ..ask.targetMetDate = null;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

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
        text: "${AskViewText.deadlineDueBy}: ${tc.ask.formattedDeadlineDate}",
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
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

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
        text: "${AskViewText.deadlineDueBy}: ${tc.ask.formattedDeadlineDate}",
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
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

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
        text: "${AskViewText.deadlineDueBy}: ${tc.ask.formattedDeadlineDate}",
      );
      expect(subtitle.style!.color, AppThemes.colorScheme.onPrimary);
      expect(subtitle.style!.decoration, null);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("TileTrailing test", () {
    testWidgets("isOnTimeline", (tester) async {
      var isOnTimeline = true;
      var isTargetMet = false;

      // isOnTimeline == true
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Material(
            child: Builder(
              builder: (BuildContext context) {
                final avatar = getTileTrailingAvatar(
                  context: context,
                  isOnTimeline: isOnTimeline,
                  isTargetMet: isTargetMet
                );
                return Scaffold(
                  body: ListedAskTileTrailing(tileTrailingAvatar: avatar,),
                );
              }
            ),
          ),
        ),
      );

      // Check CircleAvatar + Icons.local_florist shows if isOnTimeline
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.local_florist), findsOneWidget);

      // isOnTimeline == false
      isOnTimeline = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Material(
            child: Builder(
              builder: (BuildContext context) {
                final avatar = getTileTrailingAvatar(
                  context: context,
                  isOnTimeline: isOnTimeline,
                  isTargetMet: isTargetMet
                );
                return Scaffold(
                  body: ListedAskTileTrailing(tileTrailingAvatar: avatar,),
                );
              }
            ),
          ),
        ),
      );

      // Check CircleAvatar + Icons.local_florist doesn't show if !isOnTimeline
      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.byIcon(Icons.local_florist), findsNothing);
    });

    testWidgets("isTargetMet", (tester) async {
      var isOnTimeline = false;
      var isTargetMet = true;

      // isTargetMet == true
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Material(
            child: Builder(
              builder: (BuildContext context) {
                final avatar = getTileTrailingAvatar(
                  context: context,
                  isOnTimeline: isOnTimeline,
                  isTargetMet: isTargetMet
                );
                return Scaffold(
                  body: ListedAskTileTrailing(tileTrailingAvatar: avatar,),
                );
              }
            ),
          ),
        ),
      );

      // Check CircleAvatar + Icons.check shows if isTargetMet
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      // isOnTimeline == false
      isTargetMet = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Material(
            child: Builder(
              builder: (BuildContext context) {
                final avatar = getTileTrailingAvatar(
                  context: context,
                  isOnTimeline: isOnTimeline,
                  isTargetMet: isTargetMet
                );
                return Scaffold(
                  body: ListedAskTileTrailing(tileTrailingAvatar: avatar,),
                );
              }
            ),
          ),
        ),
      );

      // Check CircleAvatar + Icons.check doesn't show if !isTargetMet
      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.byIcon(Icons.check), findsNothing);
    });

  });
}