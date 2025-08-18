import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("GardensRepository", () {
    test("bulkDelete", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

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
          getGardenRecordModel(),
          getGardenRecordModel(),
          getGardenRecordModel(),
          getGardenRecordModel(),
        ]
      );

      await gardensRepository.bulkDelete(resultList: resultList);

      // Check delete called as many times as results
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: GardenField.creator)
      );

      // Check a ClientException is thrown
      expect(
        () async => await gardensRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("delete", () async {
      final garden = GardenFactory();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(garden.id)
      ).thenAnswer(
        (_) async => {}
      );

      await gardensRepository.delete(id: garden.id);

      // Check delete called once
      verify(() => recordService.delete(garden.id)).called(1);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(garden.id)
      ).thenThrow(
        ClientExceptionFactory(fieldName: GardenField.creator)
      );

      // Check a ClientException is thrown
      expect(
        () async => await gardensRepository.delete(id: garden.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

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
        (_) async => getGardenRecordModel()
      );

      await gardensRepository.getFirstListItem(filter: "");

      // Check getFirstListItem is called once
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(). Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: GardenField.creator)
      );

      // Check a ClientException is thrown
      expect(
        () async => await gardensRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

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
            getGardenRecordModel(),
            getGardenRecordModel(),
            getGardenRecordModel(),
          ]
        )
      );

      await gardensRepository.getList();

      // Check getList is called once
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
        ClientExceptionFactory(fieldName: GardenField.creator)
      );

      // Check a ClientException is thrown
      expect(
        () async => await gardensRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("subscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

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

      await gardensRepository.subscribe("");

      verify(() => recordService.subscribe(any(), any())).called(1);
    });

    test("unsubscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

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

      await gardensRepository.unsubscribe();

      verify(() => recordService.unsubscribe()).called(1);

      // RecordService.unsubscribe(). Now throws error
      when(
        () => recordService.unsubscribe()
      ).thenThrow(
        ClientException()
      );

      // Check a ClientException is thrown
      expect(
        () async => await gardensRepository.unsubscribe(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final garden = GardenFactory();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final gardensRepository = GardensRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(garden.id)
      ).thenAnswer(
        (_) async => getGardenRecordModel()
      );

      await gardensRepository.update(id: garden.id);

      verify(() => recordService.update(garden.id)).called(1);

      // RecordService.update(). Throws exception
      when(
        () => recordService.update(garden.id)
      ).thenThrow(
        ClientExceptionFactory(fieldName: GardenField.creator)
      );

      // Check record is null, errorsMap is not empty
      final (record, errorsMap) = await gardensRepository.update(id: garden.id);
      expect(record, null);
      expect(errorsMap.isEmpty, false);
    });
  });
}