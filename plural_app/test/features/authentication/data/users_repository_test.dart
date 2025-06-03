import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("UsersRepository tests", () {
    test("bulkDelete", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

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

      final records = ResultList<RecordModel>(
        items: [
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
        ]
      );

      await repository.bulkDelete(records: records);

      verify(() => recordService.delete(any())).called(5);
    });

    test("bulkDelete exception", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );

      final records = ResultList<RecordModel>(
        items: [
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
        ]
      );

      // Check a ClientException is thrown
      expect(
        () async => await repository.bulkDelete(records: records),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("delete", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

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

      await repository.delete(id: tc.user.id);

      verify(() => recordService.delete(any())).called(1);
    });

    test("delete exception", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await repository.delete(id: tc.user.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

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

      await repository.getFirstListItem(filter: "");

      verify(() => recordService.getFirstListItem(any())).called(1);
    });

    test("getFirstListItem exception", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await repository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

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

      await repository.getList();

      verify(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      )).called(1);
    });

    test("getList exception", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

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
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await repository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(any())
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await repository.update(id: tc.user.id);

      verify(() => recordService.update(any())).called(1);
    });
    test("update exception", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final repository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await repository.update(id: tc.user.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });
  });
}