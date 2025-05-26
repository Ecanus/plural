import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
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
        () => AppState.skipSubscribe()
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
        AskField.boon: 0,
        AskField.currency: "",
        AskField.description: "",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: 10,
        AskField.type: "",
      };

      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(
        () => AppState.skipSubscribe()
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

      // boon < targetSum. No Exception
      map[AskField.boon] = 5;
      map[AskField.targetSum] = 10;

      var (isValid1, errorsMap1) = await asksRepository.create(map);
      expect(isValid1, true);
      expect(errorsMap1, {});

      // boon >= targetSum. Raise Exception
      map[AskField.boon] = 5;
      map[AskField.targetSum] = 5;

      var (isValid2, errorsMap2) = await asksRepository.create(map);
      expect(isValid2, false);
      expect(errorsMap2.isNotEmpty, true);

      // boon < targetSum. RecordService.create() Raise Exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      map[AskField.boon] = 5;
      map[AskField.targetSum] = 10;

      var (isValid3, errorsMap3) = await asksRepository.create(map);
      expect(isValid3, false);
      expect(errorsMap3.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("update", () async {
      var map = {
        GenericField.id: "UPDATEDASKID",
        AskField.boon: 0,
        AskField.currency: "",
        AskField.description: "",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: 10,
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

      // boon < targetSum. No Exception
      map[AskField.boon] = 5;
      map[AskField.targetSum] = 10;

      var (isValid1, errorsMap1) = await asksRepository.update(map);
      expect(isValid1, true);
      expect(errorsMap1, {});

      // boon >= targetSum. Raise Exception
      map[AskField.boon] = 5;
      map[AskField.targetSum] = 4;

      var (isValid2, errorsMap2) = await asksRepository.update(map);
      expect(isValid2, false);
      expect(errorsMap2.isNotEmpty, true);

      // boon < targetSum. RecordService.update() Raise Exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      map[AskField.boon] = 5;
      map[AskField.targetSum] = 10;

      var (isValid3, errorsMap3) = await asksRepository.update(map);
      expect(isValid3, false);
      expect(errorsMap3.isNotEmpty, true);
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