import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("UsersRepository tests", () {
    test("authWithPassword", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.authWithPassword()
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenAnswer(
        (_) async => RecordAuth()
      );

      verifyNever(() => recordService.authWithPassword(any(), any()));

      await usersRepository.authWithPassword(
        "test@email.com",
        "testpassword"
      );

      verify(() => recordService.authWithPassword(any(), any())).called(1);

      // RecordService.authWithPassword(), Now throws exception
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.firstName)
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.authWithPassword(
          "test@email.com", "testpassword"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("bulkDelete", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

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
          getUserRecordModel(),
          getUserRecordModel(),
          getUserRecordModel(),
          getUserRecordModel(),
          getUserRecordModel(),
        ]
      );

      await usersRepository.bulkDelete(resultList: resultList);

      // Check delete called as many times as results
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("clearAuthStore", () async {
      final pb = MockPocketBase();
      final usersRepository = UsersRepository(pb: pb);

      // pb.authStore()
      final authStore = AuthStore();
      authStore.save("newToken", getUserRecordModel());
      when(
        () => pb.authStore
      ).thenAnswer(
        (_) => authStore
      );

      verifyNever(() => pb.authStore);

      usersRepository.clearAuthStore();

      verify(() => pb.authStore).called(1);

      // pb.authStore(), Now throws exception
      when(
        () => pb.authStore
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check a ClientException is thrown
      expect(
        () async => usersRepository.clearAuthStore(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("create", () async {
      final body = {
        UserField.email: "emailTest",
        UserField.firstName: "firstNameTest",
        UserField.lastName: "lastNameTest",
        UserField.username: "usernameTest"
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

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
        (_) async => getUserRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await usersRepository.create(body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: body)
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await usersRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("delete", () async {
      final user = AppUserFactory();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(user.id)
      ).thenAnswer(
        (_) async => {}
      );

      await usersRepository.delete(id: user.id);

      // Check delete called once
      verify(() => recordService.delete(any())).called(1);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.delete(id: user.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

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
        (_) async => getUserRecordModel()
      );

      await usersRepository.getFirstListItem(filter: "");

      // Check getFirstListItem is called once
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(). Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

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

      await usersRepository.getList();

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
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("requestPasswordReset", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.requestPasswordReset()
      when(
        () => recordService.requestPasswordReset("testEmail")
      ).thenAnswer(
        (_) async => {}
      );

      verifyNever(() => recordService.requestPasswordReset(any()));

      await usersRepository.requestPasswordReset("testEmail");

      verify(() => recordService.requestPasswordReset(any())).called(1);

      // RecordService.requestPasswordReset(), Now throws exception
      when(
        () => recordService.requestPasswordReset(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );
      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.requestPasswordReset("testEmail"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("requestVerification", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.requestVerification()
      when(
        () => recordService.requestVerification(any())
      ).thenAnswer(
        (_) async => {}
      );

      verifyNever(() => recordService.requestVerification(any()));

      await usersRepository.requestVerification("testEmail");

      verify(() => recordService.requestVerification(any())).called(1);

      // RecordService.requestVerification(), Now throws exception
      when(
        () => recordService.requestVerification(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );
      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.requestVerification("testEmail"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("subscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

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

      await usersRepository.subscribe("", () {});

      verify(() => recordService.subscribe(any(), any())).called(1);
    });

    test("unsubscribe", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

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

      await usersRepository.unsubscribe();

      verify(() => recordService.unsubscribe()).called(1);

      // RecordService.unsubscribe(). Now throws error
      when(
        () => recordService.unsubscribe()
      ).thenThrow(
        ClientException()
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.unsubscribe(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final user = AppUserFactory();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final usersRepository = UsersRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(user.id)
      ).thenAnswer(
        (_) async => getUserRecordModel(user: user)
      );

      await usersRepository.update(id: user.id);

      verify(() => recordService.update(any())).called(1);

      // RecordService.update(). Throws exception
      when(
        () => recordService.update(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: UserField.username)
      );

      // Check record is null, errorsMap is not empty
      final (record, errorsMap) = await usersRepository.update(id: user.id);
      expect(record, null);
      expect(errorsMap.isEmpty, false);
    });
  });
}