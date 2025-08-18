import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("UserSettingsRepository tests", () {
    test("bulkDelete", () async {
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
          getUserSettingsRecordModel(),
          getUserSettingsRecordModel(),
          getUserSettingsRecordModel(),
          getUserSettingsRecordModel(),
          getUserSettingsRecordModel(),
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
        ClientExceptionFactory(fieldName: UserSettingsField.defaultCurrency)
      );
      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("create", () async {
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
        () => recordService.create(body: body)
      ).thenAnswer(
        (_) async => getUserSettingsRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await userSettingsRepository.create(body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: body)
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserSettingsField.defaultCurrency)
      );
      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await userSettingsRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("delete", () async {
      final userSettings = AppUserSettingsFactory();

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
        () => recordService.delete(userSettings.id)
      ).thenAnswer(
        (_) async => {}
      );

      // Check delete() called at the right time
      verifyNever(() => recordService.delete(userSettings.id));
      await userSettingsRepository.delete(id: userSettings.id);
      verify(() => recordService.delete(userSettings.id)).called(1);

      // RecordService.delete(), Now throws exception
      when(
        () => recordService.delete(userSettings.id)
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserSettingsField.defaultCurrency)
      );
      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.delete(id: userSettings.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
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
        (_) async => getUserSettingsRecordModel()
      );

      // Check getFirstListItem() called at the right time
      verifyNever(() => recordService.getFirstListItem(any()));
      await userSettingsRepository.getFirstListItem(filter: "");
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(), Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserSettingsField.defaultCurrency)
      );
      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
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
            getUserSettingsRecordModel(),
            getUserSettingsRecordModel(),
            getUserSettingsRecordModel(),
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
        ClientExceptionFactory(fieldName: UserSettingsField.defaultCurrency)
      );

      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("subscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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

      await userSettingsRepository.subscribe();

      verify(() => recordService.subscribe(any(), any())).called(1);
    });

    test("unsubscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final userSettingsRepository = UserSettingsRepository(pb: pb);

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

      await userSettingsRepository.unsubscribe();

      verify(() => recordService.unsubscribe()).called(1);

      // RecordService.unsubscribe(). Now throws error
      when(
        () => recordService.unsubscribe()
      ).thenThrow(
        ClientException()
      );

      // Check a ClientException is thrown
      expect(
        () async => await userSettingsRepository.unsubscribe(),
        throwsA(predicate((e) => e is ClientException))
      );

    });

    test("update", () async {
      final userSettings = AppUserSettingsFactory();

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
        () => recordService.update(userSettings.id, body: body)
      ).thenAnswer(
        (_) async => getUserSettingsRecordModel(userSettings: userSettings)
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await userSettingsRepository.update(
        id: userSettings.id, body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.update(), Now throws exception
      when(
        () => recordService.update(userSettings.id, body: body)
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserSettingsField.defaultCurrency)
      );
      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await userSettingsRepository.update(
        id: userSettings.id, body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });
  });
}