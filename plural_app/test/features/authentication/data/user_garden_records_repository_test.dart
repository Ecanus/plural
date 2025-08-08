import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("UserGardenRecordsRepository", () {
    test("bulkDelete", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

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
          tc.getUserGardenRecordRecordModel(),
          tc.getUserGardenRecordRecordModel(),
          tc.getUserGardenRecordRecordModel(),
          tc.getUserGardenRecordRecordModel(),
          tc.getUserGardenRecordRecordModel(),
        ]
      );

      verifyNever(() => recordService.delete(any()));
      await userGardenRecordsRepository.bulkDelete(resultList: resultList);
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete(), Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await userGardenRecordsRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("create", () async {
      final tc = TestContext();

      final body = {
        UserGardenRecordField.garden: tc.garden.id,
        UserGardenRecordField.user: tc.user.id,
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create()
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getUserGardenRecordRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await userGardenRecordsRepository.create(body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await userGardenRecordsRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("delete", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

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

      verifyNever(() => recordService.delete(any()));
      await userGardenRecordsRepository.delete(id: tc.userGardenRecord.id);
      verify(() => recordService.delete(any())).called(1);

      // RecordService.delete(), Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await userGardenRecordsRepository.delete(id: tc.userGardenRecord.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

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
        (_) async => tc.getUserGardenRecordRecordModel()
      );

      // Check getFirstListItem is called at right time
      verifyNever(() => recordService.getFirstListItem(any()));
      await userGardenRecordsRepository.getFirstListItem(filter: "");
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(), Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await userGardenRecordsRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

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
            tc.getUserGardenRecordRecordModel(),
            tc.getUserGardenRecordRecordModel(),
            tc.getUserGardenRecordRecordModel(),
          ]
        )
      );

      // Check getList() is called at the right time
      verifyNever(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      ));

      await userGardenRecordsRepository.getList();

      verify(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      )).called(1);

      // RecordService.getList(), Now throws exception
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
        () async => await userGardenRecordsRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("subscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

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

      await userGardenRecordsRepository.subscribe("", () {});

      verify(() => recordService.subscribe(any(), any())).called(1);
    });

    test("unsubscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

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

      await userGardenRecordsRepository.unsubscribe();

      verify(() => recordService.unsubscribe()).called(1);

      // RecordService.unsubscribe(). Now throws error
      when(
        () => recordService.unsubscribe()
      ).thenThrow(
        ClientException()
      );

      // Check a ClientException is thrown
      expect(
        () async => await userGardenRecordsRepository.unsubscribe(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final tc = TestContext();

      final body = {
        UserGardenRecordField.garden: tc.garden.id,
        UserGardenRecordField.user: tc.user.id,
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userGardenRecordsRepository = UserGardenRecordsRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getUserGardenRecordRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await userGardenRecordsRepository.update(
        id: tc.userGardenRecord.id, body: body);

      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.update(), Now throws exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );
      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await userGardenRecordsRepository.update(
        id: tc.userGardenRecord.id, body: body);

      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });
  });
}