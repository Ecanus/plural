import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../test_context.dart';
import '../test_mocks.dart';

void main() {
  group("App state test", () {
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

    test("setGardenAndReroute", () async {});
  });
}