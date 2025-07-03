import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_gardens_tab.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_settings_tab.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("LandingPage test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUserSettingsRepository = MockUserSettingsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<PocketBase>(() => pb);
      getIt.registerLazySingleton<UserSettingsRepository>(() => mockUserSettingsRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      // RecordService.unsubscribe()
      when(
        () => recordService.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      // UserSettingsRepository.unsubscribe()
      when(
        () => mockUserSettingsRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );
      // UserSettingsRepository.subscribe()
      when(
        () => mockUserSettingsRepository.subscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.user])
        ])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LandingPage(exitedGardenID: null,),
        )
      );

      // Check tabs are rendered
      final gardensTab = find.text(LandingPageText.gardens);
      final settingsTab = find.text(LandingPageText.settings);
      expect(gardensTab, findsOneWidget);
      expect(settingsTab, findsOneWidget);

      // Check only Gardens tab rendered fully; Settings tab not rendered
      expect(find.byType(LandingPageGardensTab), findsOneWidget);
      expect(find.byType(LandingPageSettingsTab), findsNothing);

      // Tap on Settings tab
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();

      // Check only Settings tab rendered fully; Gardens tab not rendered
      expect(find.byType(LandingPageGardensTab), findsNothing);
      expect(find.byType(LandingPageSettingsTab), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("exitedGardenID != null", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUserSettingsRepository = MockUserSettingsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<PocketBase>(() => pb);
      getIt.registerLazySingleton<UserSettingsRepository>(() => mockUserSettingsRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      // RecordService.unsubscribe()
      when(
        () => recordService.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      // AsksRepository.getList()
      final asksResultList = ResultList<RecordModel>(items: [tc.getAskRecordModel()]);
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
        )
      ).thenAnswer(
        (_) async => asksResultList
      );
      // AsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(
          resultList: asksResultList,
        )
      ).thenAnswer(
        (_) async => {}
      );

      // UserSettingsRepository.unsubscribe()
      when(
        () => mockUserSettingsRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );
      // UserSettingsRepository.subscribe()
      when(
        () => mockUserSettingsRepository.subscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      // UserGardenRecordsRepository.getFirstListItem()
      when(
        () => mockUserGardenRecordsRepository.getFirstListItem(
          filter: any(named: "filter"),
        )
      ).thenAnswer(
        (_) async => tc.getUserGardenRecordRecordModel()
      );
      // UserGardenRecordsRepository.delete()
      when(
        () => mockUserGardenRecordsRepository.delete(
          id: any(named: "id"),
        )
      ).thenAnswer(
        (_) async => {}
      );
      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.user])
        ])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // Check database methods not yet called
      verifyNever(() => mockAsksRepository.getList(filter: any(named: "filter")));
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: asksResultList));
      verifyNever(() => mockUserGardenRecordsRepository.getFirstListItem(
        filter: any(named: "filter")
      ));
      verifyNever(() => mockUserGardenRecordsRepository.delete(id: any(named: "id")));

      // Render Landing Page
      await tester.pumpWidget(
        MaterialApp(
          home: LandingPage(exitedGardenID: tc.garden.id,),
        )
      );

      // Check database methods each called
      verify(() => mockAsksRepository.getList(filter: any(named: "filter"))).called(1);
      verify(() => mockAsksRepository.bulkDelete(resultList: asksResultList)).called(1);
      verify(() => mockUserGardenRecordsRepository.getFirstListItem(
        filter: any(named: "filter")
      )).called(1);
      verify(() => mockUserGardenRecordsRepository.delete(
        id: any(named: "id")
      )).called(1);
    });

    tearDown(() => GetIt.instance.reset());
  });
}