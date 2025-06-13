import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("UserSettingsRepository tests", () {
    test("bulkDelete", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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
          tc.getUserSettingsRecordModel(),
          tc.getUserSettingsRecordModel(),
          tc.getUserSettingsRecordModel(),
          tc.getUserSettingsRecordModel(),
          tc.getUserSettingsRecordModel(),
        ]
      );

      // Check delete() is called the right number of times, at the right time
      verifyNever(() => recordService.delete(any()));
      await userSettingsRepository.bulkDelete(resultList: resultList);
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete(), Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("create", () async {
      final tc = TestContext();

      final body = {
        UserSettingsField.defaultCurrency: "GHS",
        UserSettingsField.defaultInstructions: "test instructions",
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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
        (_) async => tc.getUserSettingsRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await userSettingsRepository.create(body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );
      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await userSettingsRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("delete", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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

      // Check delete() called at the right time
      verifyNever(() => recordService.delete(any()));
      await userSettingsRepository.delete(id: tc.userSettings.id);
      verify(() => recordService.delete(any())).called(1);

      // RecordService.delete(), Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.delete(id: tc.userSettings.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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
        (_) async => tc.getUserSettingsRecordModel()
      );

      // Check getFirstListItem() called at the right time
      verifyNever(() => recordService.getFirstListItem(any()));
      await userSettingsRepository.getFirstListItem(filter: "");
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(), Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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
            tc.getUserSettingsRecordModel(),
            tc.getUserSettingsRecordModel(),
            tc.getUserSettingsRecordModel(),
          ]
        )
      );

      // Check getList() called at the right time
      verifyNever(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      ));

      await userSettingsRepository.getList();

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
        () async => await userSettingsRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final tc = TestContext();

      final body = {
        UserSettingsField.defaultCurrency: "GHS",
        UserSettingsField.defaultInstructions: "test instructions",
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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
        (_) async => tc.getUserSettingsRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await userSettingsRepository.update(
        id: tc.userSettings.id, body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.update(), Now throws exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );
      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await userSettingsRepository.update(
        id: tc.userSettings.id, body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });
  });
}