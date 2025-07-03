import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("UsersRepository tests", () {
    test("authWithPassword", () async {
      final tc = TestContext();

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
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.authWithPassword(
          "test@email.com", "testpassword"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("bulkDelete", () async {
      final tc = TestContext();

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
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
          tc.getUserRecordModel(),
        ]
      );

      await usersRepository.bulkDelete(resultList: resultList);

      // Check delete called as many times as results
      verify(() => recordService.delete(any())).called(resultList.items.length);

      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.bulkDelete(resultList: resultList),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("clearAuthStore", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final usersRepository = UsersRepository(pb: pb);

      // pb.authStore()
      final authStore = AuthStore();
      authStore.save("newToken", tc.getUserRecordModel());
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
        tc.clientException
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

      final tc = TestContext();
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
        () => recordService.create(body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await usersRepository.create(body: body);
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await usersRepository.create(body: body);
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("delete", () async {
      final tc = TestContext();

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

      await usersRepository.delete(id: tc.user.id);

      // Check delete called once
      verify(() => recordService.delete(any())).called(1);

      // RecordService.delete(). Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.delete(id: tc.user.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getFirstListItem", () async {
      final tc = TestContext();

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
        (_) async => tc.getUserRecordModel()
      );

      await usersRepository.getFirstListItem(filter: "");

      // Check getFirstListItem is called once
      verify(() => recordService.getFirstListItem(any())).called(1);

      // RecordService.getFirstListItem(). Now throws exception
      when(
        () => recordService.getFirstListItem(any())
      ).thenThrow(
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.getFirstListItem(filter: ""),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
      final tc = TestContext();

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
            tc.getUserRecordModel(),
            tc.getUserRecordModel(),
            tc.getUserRecordModel(),
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
        tc.clientException
      );

      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("requestPasswordReset", () async {
      final tc = TestContext();

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
        () => recordService.requestPasswordReset(any())
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
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.requestPasswordReset("testEmail"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("requestVerification", () async {
      final tc = TestContext();

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
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await usersRepository.requestVerification("testEmail"),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final tc = TestContext();

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
        () => recordService.update(any())
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await usersRepository.update(id: tc.user.id);

      verify(() => recordService.update(any())).called(1);

      // RecordService.update(). Throws exception
      when(
        () => recordService.update(any())
      ).thenThrow(
        tc.clientException
      );

      // Check record is null, errorsMap is not empty
      final (record, errorsMap) = await usersRepository.update(id: tc.user.id);
      expect(record, null);
      expect(errorsMap.isEmpty, false);
    });
  });
}