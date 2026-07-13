import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/examine_do_document_view.dart';

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
  group("ExamineDoDocumentView", () {
    testWidgets("uncheck-check", (tester) async {
      final now = DateTime.now();

      final garden = GardenFactory(
        doDocumentEditDate: now,
      );
      final userGardenRecord = AppUserGardenRecordFactory(
        doDocumentReadDate: now.add(Duration(days: -1)),
        garden: garden,
      );

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord;

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);


      // UserGardenRecordsRepository.update()
      when(
        () => mockUserGardenRecordsRepository.update(
          id: userGardenRecord.id,
          body: any(named: "body") // must use any() because DateTime.now() is called internally
        )
      ).thenAnswer(
        (_) async => (
          getUserGardenRecordRecordModel(userGardenRecord: userGardenRecord), {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: ExamineDoDocumentView(userGardenRecord: userGardenRecord,)
            )
          ),
        )
      );

      expect(find.text(DoDocumentText.markAsRead), findsOneWidget);
      expect(find.text(DoDocumentText.read), findsNothing);

      // Tap on the CheckboxListTile
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      expect(find.text(DoDocumentText.markAsRead), findsNothing);
      expect(find.text(DoDocumentText.read), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("cards", (tester) async {
      final garden = GardenFactory(
        doDocument: "this||yields||four||cards",
      );
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
      );

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord;

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);


      // UserGardenRecordsRepository.update()
      when(
        () => mockUserGardenRecordsRepository.update(
          id: userGardenRecord.id,
          body: any(named: "body") // must use any() because DateTime.now() is called internally
        )
      ).thenAnswer(
        (_) async => (
          getUserGardenRecordRecordModel(userGardenRecord: userGardenRecord), {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: ExamineDoDocumentView(userGardenRecord: userGardenRecord,)
            )
          ),
        )
      );

      // Confirm 5 cards found (4 from DoDocument + 1 from CheckboxListTile)
      expect(find.byType(Card), findsNWidgets(5));
    });

    tearDown(() => GetIt.instance.reset());
  });
}