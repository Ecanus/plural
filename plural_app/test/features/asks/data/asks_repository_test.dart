import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("AsksRepository", () {
    test("bulkDelete", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenAnswer(
        (_) async => {}
      );

      final resultList = ResultList<RecordModel>(
        items: [
          getAskRecordModel(),
          getAskRecordModel(),
          getAskRecordModel(),
        ]
      );

      await asksRepository.bulkDelete(resultList: resultList);

      // Check delete called as many times as results
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        ClientExceptionFactory.empty()
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("create", () async {
      final body = {
        AskField.boon: 0,
        AskField.currency: "",
        AskField.description: "description",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: 10,
        AskField.type: "",
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create(), No Exception
      when(
        () => recordService.create(body: body)
      ).thenAnswer(
        (_) async => getAskRecordModel()
      );

      // boon < targetSum. Check errors map is empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      final (record1, errorsMap1) = await asksRepository.create(body: body);
      expect(record1, isNotNull);
      expect(errorsMap1.isEmpty, true);



      // boon >= targetSum. Check errors map is not empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 5;

      final (record2, errorsMap2) = await asksRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);

      // RecordService.create() Raise Exception
      when(
        () => recordService.create(body: body)
      ).thenThrow(
        ClientExceptionFactory(
          exceptionMessage: "Error with ${AskField.boon}",
          fieldName: AskField.boon
        )
      );

      // boon < targetSum
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record3, errorsMap3) = await asksRepository.create(body: body);
      expect(record3, null);
      expect(errorsMap3.isEmpty, false);
    });

    test("create empty description", () async {
      final body = {
        AskField.boon: 0,
        AskField.currency: "",
        AskField.description: "",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: 10,
        AskField.type: "",
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create()
      when(
        () => recordService.create(body: body)
      ).thenAnswer(
        (_) async => getAskRecordModel()
      );

      await asksRepository.create(body: body);

      // Value for description gets changed because it was an empty string
      expect(body[AskField.description], "${body[AskField.targetSum]} ${body[AskField.currency]}");
    });

    test("delete", () async {
      final ask = AskFactory();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(ask.id)
      ).thenAnswer(
        (_) async => {}
      );

      await asksRepository.delete(id: ask.id);

      // Check delete is called once
      verify(() => recordService.delete(ask.id)).called(1);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(ask.id)
      ).thenThrow(
        ClientExceptionFactory.empty()
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.delete(id: ask.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("test_filter")
      ).thenAnswer(
        (_) async => getUserRecordModel()
      );

      await asksRepository.getFirstListItem(filter: "test_filter");

      // Check getFirstListItem called once
      verify(() => recordService.getFirstListItem("test_filter")).called(1);

      // RecordService.getFirstListItem(). Now throws exception
      when(
        () => recordService.getFirstListItem("test_filter")
      ).thenThrow(
        ClientExceptionFactory.empty()
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.getFirstListItem(filter: "test_filter"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserRecordModel(),
            getUserRecordModel(),
            getUserRecordModel(),
          ]
        )
      );

      await asksRepository.getList();

      // Check getList called once
      verify(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      )).called(1);

      // RecordService.getList(). Now throws exception
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenThrow(
        ClientExceptionFactory.empty()
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );

    });

    test("subscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );


      // RecordService.subscribe()
      Future<void> testFunc() async { return; }
      when(
        () => recordService.subscribe(any(), any())
      ).thenAnswer(
        (_) async => testFunc
      );

      verifyNever(() => recordService.subscribe(any(), any()));

      await asksRepository.subscribe("", () {});

      verify(() => recordService.subscribe(any(), any())).called(1);
    });

    test("unsubscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

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
        (_) async => {}
      );

      verifyNever(() => recordService.unsubscribe());

      await asksRepository.unsubscribe();

      verify(() => recordService.unsubscribe()).called(1);

      // RecordService.unsubscribe(). Now throws error
      when(
        () => recordService.unsubscribe()
      ).thenThrow(
        ClientException()
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.unsubscribe(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final body = {
        AskField.boon: 0,
        AskField.currency: "",
        AskField.description: "",
        AskField.deadlineDate: "",
        AskField.instructions: "",
        AskField.targetSum: 10,
        AskField.type: "",
      };

      final ask = AskFactory();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final asksRepository = AsksRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update(), No Exception
      when(
        () => recordService.update(ask.id, body: body)
      ).thenAnswer(
        (_) async => getAskRecordModel()
      );

      // boon < targetSum. Check errors map is empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record1, errorsMap1) = await asksRepository.update(id: ask.id, body: body);
      expect(record1, isNotNull);
      expect(errorsMap1.isEmpty, true);

      // boon >= targetSum. Check errors map is not empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 5;

      var (record2, errorsMap2) = await asksRepository.update(id: ask.id, body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);

      // RecordService.update() Raise Exception
      when(
        () => recordService.update(ask.id, body: body)
      ).thenThrow(
        ClientExceptionFactory(
          exceptionMessage: "Error with ${AskField.boon}",
          fieldName: AskField.boon
        )
      );

      // boon < targetSum
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record3, errorsMap3) = await asksRepository.update(id: ask.id, body: body);
      expect(record3, null);
      expect(errorsMap3.isEmpty, false);
    });
  });
}