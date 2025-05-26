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
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
    group("Ask methods test", () {
    test("createAskInstancesFromQuery", () async {
      final tc = TestContext();
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();

      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      when(() => mockAuthRepository.getUserByID(any())).thenAnswer((_) async => tc.user);

      var resultList = ResultList(items: [tc.getAskRecordModel()]);
      var listAsks = await createAskInstancesFromQuery(resultList);

      expect(listAsks.length, 1);

      var createdAsk = listAsks.first;
      expect(createdAsk, isA<Ask>());
      expect(createdAsk.id, "TESTASK1");
      expect(createdAsk.boon, 15);
      expect(createdAsk.creator, tc.user);
      expect(createdAsk.creationDate, DateTime(1995, 6, 13));
      expect(createdAsk.currency, "GHS");
      expect(createdAsk.description, "Test description of TESTASK1");
      expect(createdAsk.deadlineDate, DateTime(1995, 7, 24));
      expect(createdAsk.instructions, "Test instructions of TESTASK1");
      expect(createdAsk.sponsorIDS.isEmpty, true);
      expect(createdAsk.targetSum, 160);
      expect(createdAsk.targetMetDate, null);
      expect(createdAsk.type, AskType.monetary);
    });

    tearDown(() => GetIt.instance.reset());

    test("createAskInstancesFromQuery count", () async {
      final tc = TestContext();
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();

      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      when(() => mockAuthRepository.getUserByID(any())).thenAnswer((_) async => tc.user);

      var resultList = ResultList(
        items: [
          tc.getAskRecordModel(id: "ASK002"),
          tc.getAskRecordModel(id: "ASK003"),
          tc.getAskRecordModel(id: "ASK004"),
          tc.getAskRecordModel(id: "ASK005"),
          tc.getAskRecordModel(id: "ASK006"),
          tc.getAskRecordModel(id: "ASK007"),
        ]
      );

      var listAsks = await createAskInstancesFromQuery(resultList);
      expect(resultList.items.length, 6);
      expect(listAsks.length, 6);

      listAsks = await createAskInstancesFromQuery(resultList, count: 2);
      expect(resultList.items.length, 6);
      expect(listAsks.length, 2);

      listAsks = await createAskInstancesFromQuery(resultList, count: 4);
      expect(resultList.items.length, 6);
      expect(listAsks.length, 4);
    });

    test("getAsksForListedAsksDialog", () async {
      final tc = TestContext();
      final user = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      final nowString = DateFormat(Formats.dateYMMddHms).format(DateTime.now());

      // AsksRepository.getAsksByUserID(), target not met and deadline not passed
      final ask1 = tc.getNewAsk(
        id: "ASK001",
        targetMetDate: null,
        deadlineDate: DateTime.now().add(Duration(days: 50))
      );
      final filterString = ""
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} > '$nowString'";
      when(
        () => mockAsksRepository.getAsksByUserID(
          filterString: filterString,
          sortString: GenericField.created,
          userID: user.id
        )
      ).thenAnswer(
        (_) async => [ask1]
      );
      // AsksRepository.getAsksByUserID(), target not met and deadline passed
      final ask2 = tc.getNewAsk(
        id: "ASK002",
        targetMetDate: null,
        deadlineDate: DateTime.now().add(Duration(days: -50))
      );
      final deadlinePassedFilterString = ""
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} <= '$nowString'";
      when(
        () => mockAsksRepository.getAsksByUserID(
          filterString: deadlinePassedFilterString,
          sortString: GenericField.created,
          userID: user.id
        )
      ).thenAnswer(
        (_) async => [ask2]
      );
      // AsksRepository.getAsksByUserID(), target met
      final ask3 = tc.getNewAsk(
        id: "ASK003",
        targetMetDate: DateTime.now(),
        deadlineDate: DateTime.now().add(Duration(days: 50))
      );
      var targetMetFilterString = "&& ${AskField.targetMetDate} != null";
      when(
        () => mockAsksRepository.getAsksByUserID(
          filterString: targetMetFilterString,
          sortString: GenericField.created,
          userID: user.id
        )
      ).thenAnswer(
        (_) async => [ask3]
      );

      final asks = await getAsksForListedAsksDialog(
        userID: user.id, nowString: nowString
      );

      // Check length and order is correct
      expect(asks.length, 3);
      expect(asks[0].id, ask1.id);
      expect(asks[1].id, ask2.id);
      expect(asks[2].id, ask3.id);
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

  });
}