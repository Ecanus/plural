import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Asks api test", () {
    test("addSponsor", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      const existingUserID = "EXISTINGUSERID";
      final recordModel = tc.getAskRecordModel(sponsors: [existingUserID]);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: any(named: "id"), body: any(named: "body"))
      ).thenAnswer(
        (_) async => (recordModel, {})
      );

      // Existing ID, update() not called
      await addSponsor("", "EXISTINGUSERID");
      verifyNever(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body")));

      // New ID, update() called
      await addSponsor("", "NEWUSERID");
      verify(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body"))).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("checkBoonCeiling", () async {
      // boon == targetSum, raise error
      expect(
        () => checkBoonCeiling(100, 100),
        throwsA(
          predicate(
            (e) => e is ClientException
            && e.response[dataKey][AskField.boon][messageKey] == AppFormText.invalidBoonValue
          )
        )
      );

      // boon > targetSum, raise error
      expect(
        () => checkBoonCeiling(500, 100),
        throwsA(
          predicate(
            (e) => e is ClientException
            && e.response[dataKey][AskField.boon][messageKey] == AppFormText.invalidBoonValue
          )
        )
      );

      // boon < targetSum, no error
      expect(() => checkBoonCeiling(50, 100), returnsNormally);
    });

    test("deleteCurrentUserAsks", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      final resultList = ResultList<RecordModel>(items: [tc.getAskRecordModel()]);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => resultList
      );
      // mockAsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(resultList: resultList)
      ).thenAnswer(
        (_) async => {}
      );

      // Check no calls made yet
      verifyNever(() => mockAsksRepository.getList(filter: any(named: "filter")));
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: resultList));

      await deleteCurrentUserAsks();

      // Check calls were made
      verify(() => mockAsksRepository.getList(filter: any(named: "filter"))).called(1);
      verify(() => mockAsksRepository.bulkDelete(resultList: resultList)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksByGardenID", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
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

      // No count. Returns resultList.length
      final asksList1 = await getAsksByGardenID(gardenID: "");
      expect(asksList1.length, 3);
      expect(asksList1.first, isA<Ask>());

      // count == 2. Returns 2
      final asksList2 = await getAsksByGardenID(gardenID: "", count: 2);
      expect(asksList2.length, 2);

      // count > resultList.length. Returns resultList.length
      final asksList3 = await getAsksByGardenID(gardenID: "", count: 7);
      expect(asksList3.length, 3);
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksByUserID", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
        ])
      );

      // mockUsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var asksList = await getAsksByUserID(userID: "");

      expect(asksList.length, 2);
      expect(asksList.first, isA<Ask>());
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksForListedAsksDialog", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      final nowString = DateFormat(Formats.dateYMMddHms).format(DateTime.now());

      String formatFilterString(String filter) {
        return """
        ${AskField.creator} = '${appState.currentUser!.id}' &&
        ${AskField.garden} = '${appState.currentGarden!.id}' $filter
        """.trim();
      }

      // AsksRepository.getList(), target not met and deadline not passed
      final filterString = formatFilterString(""
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} > '$nowString'");
      when(
        () => mockAsksRepository.getList(
          filter: filterString,
          sort: GenericField.created,
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel(
          id: "ASK001",
          targetMetDate: null,
          deadlineDate: DateTime.now().add(Duration(days: 50))
        )])
      );
      // AsksRepository.getList(), target not met and deadline passed
      final deadlinePassedFilterString = formatFilterString(""
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} <= '$nowString'");
      when(
        () => mockAsksRepository.getList(
          filter: deadlinePassedFilterString,
          sort: GenericField.created,
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel(
          id: "ASK002",
          targetMetDate: null,
          deadlineDate: DateTime.now().add(Duration(days: -50))
        )])
      );
      // AsksRepository.getList(), target met
      final targetMetFilterString = formatFilterString(
        "&& ${AskField.targetMetDate} != null");
      when(
        () => mockAsksRepository.getList(
          filter: targetMetFilterString,
          sort: GenericField.created,
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel(
          id: "ASK003",
          targetMetDate: DateTime.now(),
          deadlineDate: DateTime.now().add(Duration(days: 50))
        )])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel(
          id: tc.user.id,
          email: tc.user.email,
          firstName: tc.user.firstName,
          lastName: tc.user.lastName,
          username: tc.user.username
        )
      );

      final asks = await getAsksForListedAsksDialog(
        userID: tc.user.id, nowString: nowString
      );

      // Check length and order is correct
      expect(asks.length, 3);
      expect(asks[0].id, "ASK001");
      expect(asks[1].id, "ASK002");
      expect(asks[2].id, "ASK003");
    });

    tearDown(() => GetIt.instance.reset());

    test("getAskTypeFromString", () async {
      expect(getAskTypeFromString("monetary"), AskType.monetary);

      // Check that fallback value is monetary (for now)
      expect(getAskTypeFromString("invalidValue"), AskType.monetary);
    });

    test("getParsedTargetMetDate", () async {
      // Check returns null if empty string given
      final parsedDateTime1 = getParsedTargetMetDate("");
      expect(parsedDateTime1, null);

      final parsedDateTime2 = getParsedTargetMetDate("1995-06-13");
      expect(parsedDateTime2, DateTime(1995, 06, 13));
    });

    test("removeSponsor", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      const existingUserID = "EXISTINGUSERID";
      final recordModel = tc.getAskRecordModel(sponsors: [existingUserID]);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // mockAsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: any(named: "id"), body: any(named: "body"))
      ).thenAnswer(
        (_) async => (recordModel, {})
      );

      // Existing ID, update() called
      await removeSponsor("", "EXISTINGUSERID");
      verify(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body"))).called(1);

      // New ID, update() not called
      await removeSponsor("", "NEWUSERID");
      verifyNever(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body")));
    });

    tearDown(() => GetIt.instance.reset());
  });
}