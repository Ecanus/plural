import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Tests
import '../../../test_context.dart';
import '../../../tester_functions.dart';

void main() {
  group("GardenTimelineTile", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                GardenTimelineTile(ask: tc.ask, index: 0, isAdminPage: true,)
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
                GardenTimelineTile(ask: tc.ask, index: 1, isAdminPage: false,)
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
      final tc = TestContext();
      final ask = tc.ask;

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
  });
}