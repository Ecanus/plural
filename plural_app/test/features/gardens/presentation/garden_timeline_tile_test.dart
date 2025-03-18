import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../tester_functions.dart';

void main() {
  group("GardenTimelineTile test", () {
    testWidgets("isCreatedByCurrentUser", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      // When ask.isCreatedByCurrentUser
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: tc.ask)
              ],
            ),
          )
        )
      );

      // Check EditableGardenTimelineTile rendered; not NonEditableGardenTimelineTile
      expect(find.byType(EditableGardenTimelineTile), findsOneWidget);
      expect(find.byType(NonEditableGardenTimelineTile), findsNothing);

      // When !ask.isCreatedByCurrentUser
      final now = DateTime.now();

      final newUser = AppUser(
        email: "new@user.com",
        id: "NEWUSER001",
        username: "newuser"
      );

      final newAsk = Ask(
        id: "NEWASK",
        boon: 0,
        creator: newUser,
        creationDate: now.add(const Duration(days: -10)),
        currency: "GHS",
        description: "",
        deadlineDate: now.add(const Duration(days: 90)),
        instructions: "",
        targetSum: 500,
        type: AskType.monetary
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: newAsk)
              ],
            ),
          )
        )
      );

      // Check NonEditableGardenTimelineTile rendered; not EditableGardenTimelineTile
      expect(find.byType(NonEditableGardenTimelineTile), findsOneWidget);
      expect(find.byType(EditableGardenTimelineTile), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("TileContents", (tester) async {
      final tc = TestContext();
      final ask = tc.ask;
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                TileContents(
                  ask: ask,
                  hideContent: false,
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
                  hideContent: true,
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

    tearDown(() => GetIt.instance.reset());

    testWidgets("TileIsSponsoredIcon", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: TileIsSponsoredIcon(hideContent: false,),
          )
        )
      );

      // Check icon color is onSecondary when hideContent == false
      var icon = get<Icon>(tester);
      expect(icon.color, AppThemes.colorScheme.onSecondary);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: TileIsSponsoredIcon(hideContent: true,),
          )
        )
      );

      // Check icon color is transparent when hideContent == true
      icon = get<Icon>(tester);
      expect(icon.color, Colors.transparent);
    });

    tearDown(() => GetIt.instance.reset());
  });
}