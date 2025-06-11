import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("AsksRepository tests", () {
    test("bulkDelete", () async {
      final tc = TestContext();

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
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
        ]
      );

      await asksRepository.bulkDelete(resultList: resultList);

      // Check delete called as many times as results
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
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

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create(), No Exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getAskRecordModel()
      );

      // boon < targetSum. Check errors map is empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record1, errorsMap1) = await asksRepository.create(body: body);
      expect(record1, isNotNull);
      expect(errorsMap1.isEmpty, true);

      // boon >= targetSum. Check errors map is not empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 5;

      var (record2, errorsMap2) = await asksRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);

      // RecordService.create() Raise Exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      // boon < targetSum
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record3, errorsMap3) = await asksRepository.create(body: body);
      expect(record3, null);
      expect(errorsMap3.isEmpty, false);
    });

    test("delete", () async {
      final tc = TestContext();

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

      await asksRepository.delete(id: tc.ask.id);

      // Check delete is called once
      verify(() => recordService.delete(any())).called(1);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.delete(id: tc.user.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final tc = TestContext();

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
        () => recordService.getFirstListItem(any())
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await asksRepository.getFirstListItem(filter: "");

      // Check getFirstListItem called once
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(). Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final tc = TestContext();

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
            tc.getUserRecordModel(),
            tc.getUserRecordModel(),
            tc.getUserRecordModel(),
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
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await asksRepository.getList(),
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

      final tc = TestContext();
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
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getAskRecordModel()
      );

      // boon < targetSum. Check errors map is empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record1, errorsMap1) = await asksRepository.update(id: tc.ask.id, body: body);
      expect(record1, isNotNull);
      expect(errorsMap1.isEmpty, true);

      // boon >= targetSum. Check errors map is not empty
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 5;

      var (record2, errorsMap2) = await asksRepository.update(id: tc.ask.id, body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);

      // RecordService.update() Raise Exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      // boon < targetSum
      body[AskField.boon] = 5;
      body[AskField.targetSum] = 10;

      var (record3, errorsMap3) = await asksRepository.update(id: tc.ask.id, body: body);
      expect(record3, null);
      expect(errorsMap3.isEmpty, false);
    });
  });
}