import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Auth methods test", () {
    test("login", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final mockAuthRepository = MockAuthRepository();
      final recordService = MockRecordService();

      // AuthRepository.getCurrentUserSettings()
      when(
        () => mockAuthRepository.getCurrentUserSettings()
      ).thenAnswer(
        (_) async => tc.userSettings
      );

      // pb.authStore.model
      final authStore = AuthStore();
      authStore.save("newToken", tc.getUserRecordModel());
      when(
        () => pb.authStore
      ).thenReturn(
        authStore
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.authWithPassword()
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenAnswer(
        (_) async => RecordAuth()
      );

      // (user) RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // (userSettings) RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var loginStatus1 = await login("username", "password", pb);
      expect(loginStatus1, true);

      // RecordService.authWithPassword(), throw Exception
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenThrow(
        ClientException()
      );

      var loginStatus2 = await login("username", "password", pb);
      expect(loginStatus2, false);
    });

    tearDown(() => GetIt.instance.reset());

    test("logout", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final mockBuildContext = MockBuildContext();
      final mockGoRouter = MockGoRouter();

      getIt.registerLazySingleton<PocketBase>(
        () => pb as PocketBase
      );

      // pb.authStore
      var authStore = AuthStore();
      authStore.save("newToken", tc.getUserRecordModel());
      when(
        () => pb.authStore
      ).thenReturn(
        authStore
      );

      // pb.collection
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.gardens)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.unsubscribe()
      when(
        () => recordService.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      // BuildContext.mounted
      when(
        () => mockBuildContext.mounted
      ).thenReturn(
        true
      );

      // GoRouter.go()
      when(
        () => mockGoRouter.go(any())
      ).thenReturn(null);

      await logout(mockBuildContext, goRouter: mockGoRouter);

      verify(() => pb.authStore).called(1);
      verify(() => recordService.unsubscribe()).called(4);
      verify(() => mockBuildContext.mounted).called(1);
      verify(() => mockGoRouter.go(any())).called(1);
    });

    test("signup", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      const email = "email";

      // pb.collection(Collection.users)
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create()
      when(
        () => recordService.create(body: {
          UserField.email: email,
          UserField.firstName: "firstName",
          UserField.lastName: "lastName",
          UserField.password: "password",
          UserField.passwordConfirm: "passwordConfirm",
          UserField.username: "username",
          UserField.emailVisibility: false,
        })
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.create(body: {
          UserSettingsField.defaultCurrency: "",
          UserSettingsField.defaultInstructions: "",
          UserSettingsField.user: tc.getUserRecordModel().id,
        })
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      // RecordService.requestVerification()
      when(
        () => recordService.requestVerification(email)
      ).thenAnswer(
        (_) async => {}
      );

      var (signupStatus1, errorsMap1) = await signup(
        "firstName",
        "lastName",
        "username",
        email,
        "password",
        "passwordConfirm",
        database: pb
      );

      expect(signupStatus1, true);
      expect(errorsMap1.isEmpty, true);
      verify(() => recordService.create(body: {
          UserField.email: email,
          UserField.firstName: "firstName",
          UserField.lastName: "lastName",
          UserField.password: "password",
          UserField.passwordConfirm: "passwordConfirm",
          UserField.username: "username",
          UserField.emailVisibility: false,
      })).called(1);
      verify(() => recordService.create(body: {
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
        UserSettingsField.user: tc.getUserRecordModel().id,
      })).called(1);
      verify(() => recordService.requestVerification(email)).called(1);

      // RecordService.create(), throw exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      var (signupStatus2, errorsMap2) = await signup(
        "firstName",
        "lastName",
        "username",
        email,
        "password",
        "passwordConfirm",
        database: pb
      );

      expect(signupStatus2, false);
      expect(errorsMap2.isEmpty, false);
      verifyNever(() => recordService.requestVerification(email));
    });

    test("sendPasswordResetCode", () async {
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      const email = "email";

      // pb.collection(Collection.users)
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.requestPasswordReset()
      when(
        () => recordService.requestPasswordReset(email)
      ).thenAnswer(
        (_) async => {}
      );

      var sendPasswordStatus1 = await sendPasswordResetCode(email, database: pb);
      expect(sendPasswordStatus1, true);

      // RecordService.requestPasswordReset(), throw exception
      when(
        () => recordService.requestPasswordReset(email)
      ).thenThrow(
        ClientException()
      );

      var sendPasswordStatus2 = await sendPasswordResetCode(email, database: pb);
      expect(sendPasswordStatus2, false);
    });
  });

  group("Auth repository test", () {
    test("getUserGardenRecord", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      // GetIt
      getIt.registerLazySingleton<AuthRepository>(
        () => authRepository
      );
      getIt.registerLazySingleton<GardensRepository>(
        () => GardensRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userGardenRecords)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.gardens)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.garden.id}'")
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel()
      );
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // RecordService.getList(), empty list
      when(
        () => recordService.getList(
          filter: "user = '${tc.user.id}' && garden = '${tc.garden.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      var nullRecord = await authRepository.getUserGardenRecord(
        userID: tc.user.id, gardenID: tc.garden.id);
      expect(nullRecord, null);

      // RecordService.getList()
      when(
        () => recordService.getList(
          filter: "user = '${tc.user.id}' && garden = '${tc.garden.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getGardenRecordRecordModel()])
      );

      var record = await authRepository.getUserGardenRecord(
        userID: tc.user.id, gardenID: tc.garden.id);
      expect(record!, isA<AppUserGardenRecord>());
      expect(record.id, "TESTGARDENRECORD1");
      expect(record.user, tc.user);
      expect(record.garden, tc.garden);
    });

    tearDown(() => GetIt.instance.reset());

    test("getCurrentGardenUsers", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      final AppState appState = AppState.ignoreSubscribe()
                                ..currentGarden = tc.garden;

      // GetIt
      getIt.registerLazySingleton<AppState>(
        () => appState
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userGardenRecords)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          expand: UserGardenRecordField.user,
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.user)])
      );

      var users = await authRepository.getCurrentGardenUsers();
      expect(users.length, 1);

      var thisUser = users.first;
      expect(thisUser, isA<AppUser>());
      expect(thisUser.id, tc.user.id);
      expect(thisUser.email, tc.user.email);
      expect(thisUser.username, tc.user.username);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserByID", () async {
      final tc = TestContext();
      final pb = MockPocketBase();

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var thisUser = await authRepository.getUserByID(tc.user.id);

      expect(thisUser, isA<AppUser>());
      expect(thisUser.id, "TESTUSER1");
      expect(thisUser.email, "test@user.com");
      expect(thisUser.username, "testuser");
    });

    test("getCurrentUserSettings", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);
      final AppState appState = AppState();

      appState.currentUser = tc.user;

      // GetIt
      getIt.registerLazySingleton<AppState>(
        () => appState
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var thisUser = await authRepository.getUserByID(tc.user.id);

      expect(thisUser, isA<AppUser>());
      expect(thisUser.id, "TESTUSER1");
      expect(thisUser.email, "test@user.com");
      expect(thisUser.username, "testuser");
    });

    test("updateUserSettings", () async {
      final tc = TestContext();
      final pb = MockPocketBase();

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var map = {
        GenericField.id: "",
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
      };

      var (updateStatus1, errorsMap1) = await authRepository.updateUserSettings(map);
      expect(updateStatus1, true);
      expect(errorsMap1.isEmpty, true);

      // RecordService.update(), throw exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      var (updateStatus2, errorsMap2) = await authRepository.updateUserSettings(map);
      expect(updateStatus2, false);
      expect(errorsMap2.isEmpty, false);
    });
  });
}