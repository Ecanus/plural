import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Auth api test", () {
    test("getUserByID", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      getIt.registerLazySingleton<UsersRepository>(
        () => UsersRepository(pb: pb)
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

      final appUser = await getUserByID(tc.user.id);

      expect(appUser.id, tc.user.id);
      expect(appUser.email, tc.user.email);
      expect(appUser.firstName, tc.user.firstName);
      expect(appUser.lastName, tc.user.lastName);
      expect(appUser.username, tc.user.username);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUser", () async {
      final tc = TestContext();
      final map = {
        GenericField.id: tc.user.id,
        UserField.firstName: tc.user.firstName,
        UserField.lastName: tc.user.lastName,
      };

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      getIt.registerLazySingleton<UsersRepository>(
        () => UsersRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(
          map[GenericField.id]!,
          body: {
            UserField.firstName: map[UserField.firstName],
            UserField.lastName: map[UserField.lastName],
          }
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final (isValid, errors) = await updateUser(map);

      expect(isValid, true);
      expect(errors.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUser exception", () async {
      final tc = TestContext();
      final map = {
        GenericField.id: tc.user.id,
        UserField.firstName: tc.user.firstName,
        UserField.lastName: tc.user.lastName,
      };

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      getIt.registerLazySingleton<UsersRepository>(
        () => UsersRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(
          map[GenericField.id]!,
          body: {
            UserField.firstName: map[UserField.firstName],
            UserField.lastName: map[UserField.lastName],
          }
        )
      ).thenThrow(
        tc.clientException
      );

      final (isValid, errors) = await updateUser(map);

      expect(isValid, false);
      expect(errors.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUserSettings", () async {
      final tc = TestContext();
      final map = {
        GenericField.id: tc.user.id,
        UserSettingsField.defaultCurrency: tc.userSettings.defaultCurrency,
        UserSettingsField.defaultInstructions: tc.userSettings.defaultInstructions,
      };

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      getIt.registerLazySingleton<UserSettingsRepository>(
        () => UserSettingsRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(
          map[GenericField.id]!,
          body: {
            UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
            UserSettingsField.defaultInstructions: map[
              UserSettingsField.defaultInstructions],
          }
        )
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      final (isValid, errors) = await updateUserSettings(map);

      expect(isValid, true);
      expect(errors.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUserSettings exception", () async {
      final tc = TestContext();
      final map = {
        GenericField.id: tc.user.id,
        UserSettingsField.defaultCurrency: tc.userSettings.defaultCurrency,
        UserSettingsField.defaultInstructions: tc.userSettings.defaultInstructions,
      };

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      getIt.registerLazySingleton<UserSettingsRepository>(
        () => UserSettingsRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(
          map[GenericField.id]!,
          body: {
            UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
            UserSettingsField.defaultInstructions: map[
              UserSettingsField.defaultInstructions],
          }
        )
      ).thenThrow(
        tc.clientException
      );

      final (isValid, errors) = await updateUserSettings(map);

      expect(isValid, false);
      expect(errors.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

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

    test("deleteCurrentUserAccount true", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      var appState = AppState.skipSubscribe()
        ..currentUser = tc.user
        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => AsksRepository(pb: pb));
      getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(pb: pb));

      // pb.collection(any())
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      // RecordService.getList(), Asks
      when(
        () => recordService.getList(filter: "${AskField.creator} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getAskRecordModel(), tc.getAskRecordModel()]
        )
      );
      // RecordService.getList(), UserGardenRecords
      when(
        () => recordService.getList(
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getGardenRecordRecordModel()])
      );
      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenAnswer(
        (_) async => {}
      );

      // Call deleteCurrentUserAccount()
      var isValid = await deleteCurrentUserAccount();

      expect(isValid, true);

      // Check RecordService.delete() is called 5 times
      // 2x for Asks, 1x for UserGardenRecord, 1x for UserSettings, 1x for User
      verify(() => recordService.delete(any())).called(5);
    });

    tearDown(() => GetIt.instance.reset());

    test("deleteCurrentUserAccount false", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      var appState = AppState.skipSubscribe()
        ..currentUser = tc.user
        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => AsksRepository(pb: pb));
      getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(pb: pb));

      // pb.collection(any())
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      // RecordService.getList(), Asks
      when(
        () => recordService.getList(filter: "${AskField.creator} = '${tc.user.id}'")
      ).thenThrow(
        tc.clientException
      );
      // RecordService.getList(), UserGardenRecords
      when(
        () => recordService.getList(
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getGardenRecordRecordModel()])
      );
      // RecordService.delete()
      when(
        () => recordService.delete(any())
      ).thenAnswer(
        (_) async => {}
      );

      // Call deleteCurrentUserAccount()
      var isValid = await deleteCurrentUserAccount();

      // Check returns false because of ClientException
      expect(isValid, false);

      // Check RecordService.delete() is never called
      verifyNever(() => recordService.delete(any()));
    });

    tearDown(() => GetIt.instance.reset());

  });
}