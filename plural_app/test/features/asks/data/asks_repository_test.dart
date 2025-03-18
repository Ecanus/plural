import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

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

    tearDown(() => GetIt.instance.reset());
  });

  group("Asks repository test", () {
    test("getAsksByGardenID", () async {
      final tc = TestContext();
      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final mockAuthRepository = MockAuthRepository();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      getIt.registerLazySingleton(() => mockAuthRepository as AuthRepository);
      when(() => mockAuthRepository.getUserByID(any())).thenAnswer((_) async => tc.user);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          filter: any(named: "filter"), sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      var listAsks = await asksRepository.getAsksByGardenID(gardenID: "");

      expect(listAsks.length, 1);
      expect(listAsks.first, isA<Ask>());
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksByUserID", () async {
      final tc = TestContext();
      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final mockAuthRepository = MockAuthRepository();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // GetIt
      getIt.registerLazySingleton<AppState>(
        () => AppState()
      );
      GetIt.instance<AppState>().currentGarden = tc.garden;
      getIt.registerLazySingleton(() => mockAuthRepository as AuthRepository);
      when(() => mockAuthRepository.getUserByID(any())).thenAnswer((_) async => tc.user);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          filter: any(named: "filter"), sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      var listAsks = await asksRepository.getAsksByUserID(userID: "");

      expect(listAsks.length, 1);
      expect(listAsks.first, isA<Ask>());
    });

    tearDown(() => GetIt.instance.reset());

    test("addSponsor", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      const existingUserID = "EXISTINGUSERID";
      final recordModel = tc.getAskRecordModel(sponsors: [existingUserID]);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // RecordService.update()
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => recordModel
      );

      // Existing ID, update() not called
      await asksRepository.addSponsor("", "EXISTINGUSERID");
      verifyNever(() => recordService.update(any(), body: any(named: "body")));

      // New ID, update() called
      await asksRepository.addSponsor("", "NEWUSERID");
      verify(() => recordService.update(any(), body: any(named: "body"))).called(1);
    });

    test("removeSponsor", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      const existingUserID = "EXISTINGUSERID";
      final recordModel = tc.getAskRecordModel(sponsors: [existingUserID]);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // RecordService.update()
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => recordModel
      );

      // Existing ID, update() called
      await asksRepository.removeSponsor("", "EXISTINGUSERID");
      verify(() => recordService.update(any(), body: any(named: "body"))).called(1);

      // New ID, update() not called
      await asksRepository.removeSponsor("", "NEWUSERID");
      verifyNever(() => recordService.update(any(), body: any(named: "body")));
    });

    test("create", () async {
      var map = {
        AskField.boon: "",
        AskField.currency: "",
        AskField.description: "",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: "",
        AskField.type: "",
      };

      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(
        () => AppState()
      );
      GetIt.instance<AppState>().currentUser = tc.user;
      GetIt.instance<AppState>().currentGarden = tc.garden;

      final recordModel = tc.getAskRecordModel();

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create() No Exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenAnswer(
        (_) async => recordModel
      );

      var (isValid1, errorsMap1) = await asksRepository.create(map);
      expect(isValid1, true);
      expect(errorsMap1, {});

      // RecordService.create() Raise Exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      var (isValid2, errorsMap2) = await asksRepository.create(map);
      expect(isValid2, false);
      expect(errorsMap2.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("update", () async {
      var map = {
        GenericField.id: "UPDATEDASKID",
        AskField.boon: "",
        AskField.currency: "",
        AskField.description: "",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: "",
        AskField.type: "",
      };

      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      final recordModel = tc.getAskRecordModel();

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update() No Exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => recordModel
      );

      var (isValid1, errorsMap1) = await asksRepository.update(map);
      expect(isValid1, true);
      expect(errorsMap1, {});

      // RecordService.update() Raise Exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      var (isValid2, errorsMap2) = await asksRepository.update(map);
      expect(isValid2, false);
      expect(errorsMap2.isNotEmpty, true);
    });

    test("delete", () async {
      var map = {
        GenericField.id: "UPDATEDASKID",
      };

      var clientException = ClientException(
        originalError: "Original error message",
        response: {
          "data": {
            "FieldKey": {
              "message": "The inner map message of delete()"
            }
          }
        },
      );

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete() No Exception
      when(
        () => recordService.delete(any())
      ).thenAnswer(
        (_) async {}
      );

      var (isValid1, errorsMap1) = await asksRepository.delete(map);
      expect(isValid1, true);
      expect(errorsMap1, {});

      // RecordService.delete() Raise Exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        clientException
      );

      var (isValid2, errorsMap2) = await asksRepository.delete(map);
      expect(isValid2, false);
      expect(errorsMap2, {});
    });
  });
}