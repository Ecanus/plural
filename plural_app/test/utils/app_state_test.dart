import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../test_context.dart';
import '../test_mocks.dart';

void main() {
  group("AppState", () {
    test("getTimelineAsks", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final asks = await appState.getTimelineAsks();
      expect(asks.length, 1);

      final ask = asks.first;
      expect(ask, isA<Ask>());
      expect(ask.id, "TESTASK1");
      expect(ask.boon, 15);
      expect(ask.creator, tc.user);
      expect(ask.creationDate, DateTime(1995, 6, 13));
      expect(ask.currency, "GHS");
      expect(ask.description, "Test description of TESTASK1");
      expect(ask.deadlineDate, DateTime(1995, 7, 24));
      expect(ask.instructions, "Test instructions of TESTASK1");
      expect(ask.sponsorIDS.isEmpty, true);
      expect(ask.targetSum, 160);
      expect(ask.targetMetDate, null);
      expect(ask.type, AskType.monetary);
    });

    tearDown(() => GetIt.instance.reset());

    test("refreshTimelineAsks", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final asks = await appState.getTimelineAsks();
      expect(asks.length, 1);

      // refreshTimelineAsks() should clear AppState._timelineAsks
      // (update shouldn't occur though because nothing to notify)
      appState.refreshTimelineAsks();
      expect(asks.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("setGardenAndReroute", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = null
                        ..currentUser = tc.user;

      final mockBuildContext = MockBuildContext();
      final mockGoRouter = MockGoRouter();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: any(named: "sort")
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: []
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'"
          )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // BuildContext.mounted
      when(
        () => mockBuildContext.mounted
      ).thenReturn(
        true
      );

      // GoRouter.refresh()
      when(
        () => mockGoRouter.refresh()
      ).thenReturn(null);

      // Check currentGarden is null
      expect(appState.currentGarden, null);

      // Check methods not yet called
      verifyNever(() => mockBuildContext.mounted);
      verifyNever(() => mockGoRouter.refresh());

      await appState.setGardenAndReroute(
        mockBuildContext,
        tc.garden,
        goRouter: mockGoRouter,
        showsSnackbar: false
      );

      // Check curerentGarden is still null (was never set because no userGardenRecord was found)
      expect(appState.currentGarden, null);

      // Check methods were called
      verify(() => mockBuildContext.mounted).called(1);
      verify(() => mockGoRouter.refresh()).called(1);

      // UserGardenRecordsRepository.getList(), now returns RecordModel
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: any(named: "sort")
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel([
              UserGardenRecordField.user, UserGardenRecordField.garden
            ], role: AppUserGardenRole.member),
          ]
        )
      );

      // GoRouter.go()
      when(
        () => mockGoRouter.go(any())
      ).thenReturn(null);

      // Check currentGarden is null (call not yet made)
      expect(appState.currentGarden, null);

      // Check methods not yet called
      verifyNever(() => mockBuildContext.mounted);
      verifyNever(() => mockGoRouter.go(any()));

      await appState.setGardenAndReroute(
        mockBuildContext, tc.garden, goRouter: mockGoRouter);

      // Check curerentGarden is now set
      expect(appState.currentGarden, tc.garden);

      // Check methods were called
      verify(() => mockBuildContext.mounted).called(1);
      verify(() => mockGoRouter.go(any())).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("isAdministrator, isOwner", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.member)
          ]
        )
      );

      expect(await appState.isAdministrator(), false);
      expect(await appState.isOwner(), false);

      // UserGardenRecordsRepository.getList(). Returns record with role == administrator
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
          ]
        )
      );

      expect(await appState.isAdministrator(), true);
      expect(await appState.isOwner(), false);

      // UserGardenRecordsRepository.getList(). Returns record with role == owner
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.owner)
          ]
        )
      );

      expect(await appState.isAdministrator(), true);
      expect(await appState.isOwner(), true);
    });

  });
}