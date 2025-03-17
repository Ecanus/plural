import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/non_editable_ask_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("AskDialogView test", () {
    testWidgets("widgets", (tester) async {
      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async {
        return gesture.removePointer();
      });

      final tc = TestContext();
      final ask = tc.ask;
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createNonEditableAskDialog(
                    context: context, ask: ask),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Gesture handling
      await gesture.addPointer();
      await gesture.moveTo(const Offset(1.0, 1.0));
      await tester.pump();

      // Check AskDialogView not yet displayed
      expect(find.byType(AskDialogView), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(NonEditableAskHeader), findsOneWidget);
      expect(find.text(ask.description), findsOneWidget);
      expect(find.text("${ask.boon.toString()} ${ask.currency}"), findsOneWidget);
      expect(find.text(ask.instructions), findsOneWidget);
      expect(find.text(ask.creator.username), findsOneWidget);
      expect(find.byType(AppDialogFooter), findsOneWidget);

      // Check isSponsored tooltip message is correct
      var tooltip = find.byType(Tooltip).first;
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      expect(find.text(AskDialogText.markAsSponsored), findsOneWidget);

      // Check boon tooltip message is correct
      tooltip = find.byType(Tooltip).last;
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      expect(find.text(AskDialogText.tooltipBoon), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("NonEditableAskHeader test", () {
    testWidgets("_isSponsored", (tester) async {
      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async {
        return gesture.removePointer();
      });

      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.addSponsor()
      when(
        () => mockAsksRepository.addSponsor(any(), any())
      ).thenAnswer(
        (_) async => tc.ask.sponsorIDS.add(tc.user.id)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NonEditableAskHeader(ask: tc.ask)
          ),
        )
      );

      // Check isSponsored tooltip message is correct
      var tooltip = find.byType(Tooltip);
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      expect(find.text(AskDialogText.markAsSponsored), findsOneWidget);

      // Move cursor off tooltip; toggle switch; move cursor back
      // NOTE: Switch will add tc.user to tc.ask.sponsors
      await gesture.moveTo(const Offset(1.0, 1.0));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch));
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      // Check that tooltip text has changed
      expect(find.text(AskDialogText.unmarkAsSponsored), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("BoonColumn test", () {
    testWidgets("boon", (tester) async {
      final tc = TestContext();
      tc.ask.boon = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoonColumn(ask: tc.ask)
          ),
        )
      );

      // No relevant text renders when boon <= 0
      expect(find.text(AskDialogText.boon), findsNothing);
      expect(find.byType(Tooltip), findsNothing);
      expect(find.text("${tc.ask.boon.toString()} ${tc.ask.currency}"), findsNothing);

      // Set boon > 0
      tc.ask.boon = 10;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoonColumn(ask: tc.ask)
          ),
        )
      );

      // Check text renders when boon > 0
      expect(find.text(AskDialogText.boon), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);
      expect(find.text("${tc.ask.boon.toString()} ${tc.ask.currency}"), findsOneWidget);
    });
  });
}