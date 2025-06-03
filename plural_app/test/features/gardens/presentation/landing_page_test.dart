import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

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
      final mockAuthRepository = MockAuthRepository();
      final mockGardensRepository = MockGardensRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<PocketBase>(() => pb);

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

      // AuthRepository.subscribeToUserSettings()
      when(
        () => mockAuthRepository.subscribeToUserSettings()
      ).thenAnswer(
        (_) async => () {}
      );

      // GardensRepository.getGardensByUser()
      when(
        () => mockGardensRepository.getGardensByUser(any())
      ).thenAnswer(
        (_) async => [tc.garden]
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
      final mockAuthRepository = MockAuthRepository();
      final mockGardensRepository = MockGardensRepository();

      getIt.registerLazySingleton<PocketBase>(() => pb);
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<AsksRepository>(() => AsksRepository(pb: pb));
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => UserGardenRecordsRepository(pb: pb));

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
      // RecordService.getList() - AsksRepository
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );
      // RecordService.getFirstListItem() - UserGardenRecordsRepository
      when(
        () => recordService.getFirstListItem(any())
      ).thenAnswer(
        (_) async => tc.getGardenRecordRecordModel()
      );
      // RecordService.delete() - AsksRepository & UserGardenRecordsRepository
      when(
        () => recordService.delete(any())
      ).thenAnswer(
        (_) async => {}
      );

      // AuthRepository.subscribeToUserSettings()
      when(
        () => mockAuthRepository.subscribeToUserSettings()
      ).thenAnswer(
        (_) async => () {}
      );

      // GardensRepository.getGardensByUser()
      when(
        () => mockGardensRepository.getGardensByUser(any())
      ).thenAnswer(
        (_) async => [tc.garden]
      );

      // Check database methods not yet called
      verifyNever(() =>  recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      );
      verifyNever(() => recordService.getFirstListItem(any()));
      verifyNever(() => recordService.delete(any()));

      // Render Landing Page
      await tester.pumpWidget(
        MaterialApp(
          home: LandingPage(exitedGardenID: tc.garden.id,),
        )
      );

      // Check database methods each called
      verify(() =>  recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).called(1);
      verify(() => recordService.getFirstListItem(any())).called(1);
      verify(() => recordService.delete(any())).called(2); // 1 for Ask, 1 for UserGardenRecord

    });

    tearDown(() => GetIt.instance.reset());

  });
}