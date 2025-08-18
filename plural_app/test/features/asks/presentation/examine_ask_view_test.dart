import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_tooltip_icon.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/examine_ask_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("ExamineAskView", () {
    testWidgets("widgets", (tester) async {
      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async {
        return gesture.removePointer();
      });

      final user = AppUserFactory();
      final ask = AskFactory(creator: user);

      final appState = AppState.skipSubscribe()
        ..currentUser = user; // for ask.isSponsoredByCurrentUser

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createExamineAskDialog(
                    context: context, ask: ask),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check AskDialogView not yet displayed
      expect(find.byType(ExamineAskView), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(ExamineAskViewHeader), findsOneWidget);
      expect(find.text(ask.description), findsOneWidget);
      expect(find.text("${ask.boon.toString()} ${ask.currency}"), findsOneWidget);
      expect(find.text(ask.instructions), findsOneWidget);
      expect(find.text(ask.creator.username), findsOneWidget);
      expect(find.byType(AppDialogFooter), findsOneWidget);

      // Check isSponsored tooltip message is correct
      var tooltip = find.byType(AppTooltipIcon).first;
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      expect(find.text(AskViewText.markAsSponsored), findsOneWidget);

      // Check boon tooltip message is correct
      tooltip = find.byType(AppTooltipIcon).last;
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      expect(find.text(AskViewText.tooltipBoon), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("ExamineAskViewHeader", () {
    testWidgets("_isSponsored", (tester) async {
      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async {
        return gesture.removePointer();
      });

      final user = AppUserFactory();
      final ask = AskFactory();

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.getList via asks_api.addSponsor()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async =>  ResultList<RecordModel>(items: [getAskRecordModel(ask: ask)])
      );

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: any(named: "id"), body: any(named: "body"))
      ).thenAnswer(
        (_) async => (getAskRecordModel(ask: ask), {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExamineAskViewHeader(ask: ask)
          ),
        )
      );

      // Check isSponsored tooltip message is correct
      var tooltip = find.byType(Tooltip);
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      expect(find.text(AskViewText.markAsSponsored), findsOneWidget);

      // Move cursor off tooltip; toggle switch; move cursor back
      // NOTE: Switch will add tc.user to tc.ask.sponsors
      await gesture.moveTo(const Offset(1.0, 1.0));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch));
      await gesture.moveTo(tester.getCenter(tooltip));
      await tester.pumpAndSettle();

      // Check that tooltip text has changed
      expect(find.text(AskViewText.unmarkAsSponsored), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("BoonColumn test", () {
    testWidgets("boon", (tester) async {
      final ask = AskFactory();

      ask.boon = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoonColumn(ask: ask)
          ),
        )
      );

      // No relevant text renders when boon <= 0
      expect(find.text(AskViewText.boon), findsNothing);
      expect(find.byType(Tooltip), findsNothing);
      expect(find.text("${ask.boon.toString()} ${ask.currency}"), findsNothing);

      // Set boon > 0
      ask.boon = 10;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoonColumn(ask: ask)
          ),
        )
      );

      // Check text renders when boon > 0
      expect(find.text(AskViewText.boon), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);
      expect(find.text("${ask.boon.toString()} ${ask.currency}"), findsOneWidget);
    });
  });
}