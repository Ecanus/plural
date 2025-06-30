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
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Auth api test", () {
    test("deleteCurrentUserAccount", () async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                      ..currentUser = tc.user
                      ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUserSettingsRepository = MockUserSettingsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      final asksResultList = ResultList<RecordModel>(
        items: [tc.getAskRecordModel(), tc.getAskRecordModel()]
      );
      final userGardenRecordsResultList = ResultList<RecordModel>(
        items: [tc.getUserGardenRecordRecordModel(), tc.getUserGardenRecordRecordModel()]
      );

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: "${AskField.creator} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => asksResultList
      );
      // AsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(resultList: asksResultList)
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => userGardenRecordsResultList
      );
      // UserGardenRecordsRepository.bulkDelete()
      when(
        () => mockUserGardenRecordsRepository.bulkDelete(
          resultList: userGardenRecordsResultList)
      ).thenAnswer(
        (_) async => {}
      );

      // UserSettingsRepository.delete()
      when(
        () => mockUserSettingsRepository.delete(id: tc.userSettings.id)
      ).thenAnswer(
        (_) async => {}
      );

      // UsersRepository.delete()
      when(
        () => mockUsersRepository.delete(id: tc.user.id)
      ).thenAnswer(
        (_) async => {}
      );

      // Check delete methods are not yet called
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: asksResultList));
      verifyNever(() => mockUserGardenRecordsRepository.bulkDelete(
        resultList: userGardenRecordsResultList)
      );
      verifyNever(() => mockUserSettingsRepository.delete(id: tc.userSettings.id));
      verifyNever(() => mockUsersRepository.delete(id: tc.user.id));

      // Call deleteCurrentUserAccount()
      final isValid = await deleteCurrentUserAccount();
      expect(isValid, true);

      // Check delete methods were called the correct number of times
      verify(() => mockAsksRepository.bulkDelete(resultList: asksResultList)).called(1);
      verify(() => mockUserGardenRecordsRepository.bulkDelete(
        resultList: userGardenRecordsResultList)
      ).called(1);
      verify(() => mockUserSettingsRepository.delete(id: tc.userSettings.id)).called(1);
      verify(() => mockUsersRepository.delete(id: tc.user.id)).called(1);

      // AsksRepository.getList(), Now throws exception
      when(
        () => mockAsksRepository.getList(filter: "${AskField.creator} = '${tc.user.id}'")
      ).thenThrow(
        tc.clientException
      );

      // Call deleteCurrentUserAccount()
      final isValid2 = await deleteCurrentUserAccount();
      expect(isValid2, false);

      // Check after that delete methods never called
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: asksResultList));
      verifyNever(() => mockUserGardenRecordsRepository.bulkDelete(
        resultList: userGardenRecordsResultList)
      );
      verifyNever(() => mockUserSettingsRepository.delete(id: tc.userSettings.id));
      verifyNever(() => mockUsersRepository.delete(id: tc.user.id));
    });

    tearDown(() => GetIt.instance.reset());

    test("deleteCurrentUserGardenRecords", () async {
      final tc = TestContext();

      var appState = AppState.skipSubscribe()
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);

      final userGardenRecordsResultList = ResultList<RecordModel>(
        items: [tc.getUserGardenRecordRecordModel(), tc.getUserGardenRecordRecordModel()]
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => userGardenRecordsResultList
      );
      // UserGardenRecordsRepository.bulkDelete()
      when(
        () => mockUserGardenRecordsRepository.bulkDelete(
          resultList: userGardenRecordsResultList)
      ).thenAnswer(
        (_) async => {}
      );

      // Check methods not yet called
      verifyNever(() => mockUserGardenRecordsRepository.getList(
        filter: "${UserGardenRecordField.user} = '${tc.user.id}'")
      );
      verifyNever(() => mockUserGardenRecordsRepository.bulkDelete(
        resultList: userGardenRecordsResultList)
      );

      await deleteCurrentUserGardenRecords();

      // Check methods called
      verify(() => mockUserGardenRecordsRepository.getList(
        filter: "${UserGardenRecordField.user} = '${tc.user.id}'")
      ).called(1);
      verify(() => mockUserGardenRecordsRepository.bulkDelete(
        resultList: userGardenRecordsResultList)
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("deleteCurrentUser", () async {
      final tc = TestContext();

      var appState = AppState.skipSubscribe()
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UsersRepository.delete()
      when(
        () => mockUsersRepository.delete(id: tc.user.id)
      ).thenAnswer(
        (_) async => {}
      );

      // Check delete method not yet called
      verifyNever(() => mockUsersRepository.delete(id: tc.user.id));

      await deleteCurrentUser();

      // Check delete method not yet called
      verify(() => mockUsersRepository.delete(id: tc.user.id)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("deleteCurrentUserSettings", () async {
      final tc = TestContext();

      var appState = AppState.skipSubscribe()
                      ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      final mockUserSettingsRepository = MockUserSettingsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository);

      // UserSettingsRepository.delete()
      when(
        () => mockUserSettingsRepository.delete(id: tc.userSettings.id)
      ).thenAnswer(
        (_) async => {}
      );

      // Check delete method not yet called
      verifyNever(() => mockUserSettingsRepository.delete(id: tc.userSettings.id));

      await deleteCurrentUserSettings();

      // Check delete method not yet called
      verify(() => mockUserSettingsRepository.delete(id: tc.userSettings.id)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("getCurrentGardenUsers", () async {
      final tc = TestContext();

      var appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: UserGardenRecordField.user,
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.user),
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.user),
          ]
        )
      );

      final usersList = await getCurrentGardenUsers();

      expect(usersList.length, 2);
      expect(usersList.first, isA<AppUser>());
    });

    tearDown(() => GetIt.instance.reset());

    test("getCurrentUserSettings", () async {
      final tc = TestContext();

      var appState = AppState.skipSubscribe()
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserSettingsRepository = MockUserSettingsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository);

      // UserSettingsRepository.getFirstListItem()
      when(
        () => mockUserSettingsRepository.getFirstListItem(
          filter: "${UserSettingsField.user} = '${tc.user.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel(
          defaultCurrency: "GHS",
          defaultInstructions: "Test default instructions"
        )
      );

      final userSettings = await getCurrentUserSettings();

      expect(userSettings, isA<AppUserSettings>());
      expect(userSettings.defaultCurrency, "GHS");
      expect(userSettings.defaultInstructions, "Test default instructions");
      expect(userSettings.user, tc.user);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserByID", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'"
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final appUser = await getUserByID(tc.user.id);

      expect(appUser, isA<AppUser>());
      expect(appUser.id, tc.user.id);
      expect(appUser.email, tc.user.email);
      expect(appUser.firstName, tc.user.firstName);
      expect(appUser.lastName, tc.user.lastName);
      expect(appUser.username, tc.user.username);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserGardenPermissionGroup", () async {
      // Member permissions
      expect(
        getUserGardenPermissionGroup(AppUserGardenRole.member),
        [AppUserGardenPermission.createAsks]
      );

      // Moderator permissions
      expect(
        getUserGardenPermissionGroup(AppUserGardenRole.moderator),
        [
          AppUserGardenPermission.createAsks,
          AppUserGardenPermission.changeGardenName,
          AppUserGardenPermission.changeMemberRoles,
          AppUserGardenPermission.createAsks,
          AppUserGardenPermission.createInvitations,
          AppUserGardenPermission.deleteMemberAsks,
          AppUserGardenPermission.enterModView,
          AppUserGardenPermission.kickMembers,
          AppUserGardenPermission.viewAuditLog,
        ]
      );

      // Owner permissions
      expect(
        getUserGardenPermissionGroup(AppUserGardenRole.owner),
        [
          AppUserGardenPermission.createAsks,
          AppUserGardenPermission.changeGardenName,
          AppUserGardenPermission.changeMemberRoles,
          AppUserGardenPermission.createAsks,
          AppUserGardenPermission.createInvitations,
          AppUserGardenPermission.deleteMemberAsks,
          AppUserGardenPermission.enterModView,
          AppUserGardenPermission.kickMembers,
          AppUserGardenPermission.viewAuditLog,
          AppUserGardenPermission.deleteGarden,
        ]
      );
    });

    test("getUserGardenRecord", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);


      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getUserGardenRecordRecordModel(id: "TestGardenRecordID")]
        )
      );

      // GardensRepository.getFirstListItem()
      when(
        () => mockGardensRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.garden.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel()
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final userGardenRecord = await getUserGardenRecord(
        userID: tc.user.id,
        gardenID: tc.garden.id
      );

      expect(userGardenRecord!, isA<AppUserGardenRecord>());
      expect(userGardenRecord.garden, tc.garden);
      expect(userGardenRecord.id, "TestGardenRecordID");
      expect(userGardenRecord.role, AppUserGardenRole.member);
      expect(userGardenRecord.user, tc.user);

      // UserGardenRecordsRepository.getList(), Now returns empty list
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: []
        )
      );

      final userGardenRecord2 = await getUserGardenRecord(
        userID: tc.user.id,
        gardenID: tc.garden.id
      );

      // Check null is now returned
      expect(userGardenRecord2, null);

    });

    tearDown(() => GetIt.instance.reset());

    test("getUserGardenRoleFromString", () async {
      expect(getUserGardenRoleFromString("member"), AppUserGardenRole.member);
      expect(getUserGardenRoleFromString("moderator"), AppUserGardenRole.moderator);
      expect(getUserGardenRoleFromString("owner"), AppUserGardenRole.owner);

      // Check that fallback value is member
      expect(getUserGardenRoleFromString("invalidValue"), AppUserGardenRole.member);
    });

    test("login", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();

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
      // pb.authStore.model
      final authStore = AuthStore();
      authStore.save("newToken", tc.getUserRecordModel());
      when(
        () => pb.authStore
      ).thenReturn(
        authStore
      );

      // RecordService.getFirstListItem() (UsersRepository)
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      // RecordService.getFirstListItem() (UsersRepository)
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'"
        )
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var loginStatus1 = await login("username", "password", database: pb);
      expect(loginStatus1, true);

      // RecordService.authWithPassword(), throw Exception
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenThrow(
        ClientException()
      );

      var loginStatus2 = await login("username", "password", database: pb);
      expect(loginStatus2, false);
    });

    tearDown(() => GetIt.instance.reset());

    test("logout", () async {
      final mockBuildContext = MockBuildContext();
      final mockGoRouter = MockGoRouter();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockGardenRepository = MockGardensRepository();
      final mockUserSettingsRepository = MockUserSettingsRepository();
      final mockUsersRepository = MockUsersRepository();

      // getIt.registerLazySingleton<PocketBase>(() => pb as PocketBase);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardenRepository);
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // _.unsubscribe()
      when(
        () => mockAsksRepository.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );
      when(
        () => mockGardenRepository.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );
      when(
        () => mockUserSettingsRepository.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );
      when(
        () => mockUsersRepository.unsubscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      // UsersRepository.clearAuthStore()
      when(
        () => mockUsersRepository.clearAuthStore()
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

      // Check no calls before logout()
      verifyNever(() => mockAsksRepository.unsubscribe());
      verifyNever(() => mockGardenRepository.unsubscribe());
      verifyNever(() => mockUserSettingsRepository.unsubscribe());
      verifyNever(() => mockUsersRepository.unsubscribe());
      verifyNever(() => mockUsersRepository.clearAuthStore());
      verifyNever(() => mockBuildContext.mounted);
      verifyNever(() => mockGoRouter.go(any()));

      await logout(mockBuildContext, goRouter: mockGoRouter);

      // Check all methods called after logout()
      verify(() => mockAsksRepository.unsubscribe()).called(1);
      verify(() => mockGardenRepository.unsubscribe()).called(1);
      verify(() => mockUserSettingsRepository.unsubscribe()).called(1);
      verify(() => mockUsersRepository.unsubscribe()).called(1);
      verify(() => mockUsersRepository.clearAuthStore()).called(1);
      verify(() => mockBuildContext.mounted).called(1);
      verify(() => mockGoRouter.go(any())).called(1);
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

    test("signup", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      final Map<String, dynamic> body = {
        UserField.email:  "email",
        UserField.firstName: "firstName",
        UserField.lastName: "lastName",
        UserField.password: "password",
        UserField.passwordConfirm: "passwordConfirm",
        UserField.username: "username",
        UserField.emailVisibility: false,
      };

      // pb.collection(Collection.users)
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      // pb.collection(Collection.userSettings)
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create()
      when(
        () => recordService.create(body: body)
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.create(body: {
          UserSettingsField.defaultCurrency: "",
          UserSettingsField.defaultInstructions: "",
          UserSettingsField.user: tc.user.id,
        })
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      // RecordService.requestVerification()
      when(
        () => recordService.requestVerification(body[UserField.email])
      ).thenAnswer(
        (_) async => {}
      );

      var (signupStatus1, errorsMap1) = await signup(
        body,
        database: pb
      );

      expect(signupStatus1, true);
      expect(errorsMap1.isEmpty, true);
      verify(() => recordService.create(body: body)).called(1);
      verify(() => recordService.create(body: {
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
        UserSettingsField.user: tc.getUserRecordModel().id,
      })).called(1);
      verify(() => recordService.requestVerification(body[UserField.email])).called(1);

      // RecordService.create(), throw exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      var (signupStatus2, errorsMap2) = await signup(
        body,
        database: pb
      );

      expect(signupStatus2, false);
      expect(errorsMap2.isEmpty, false);
      verifyNever(() => recordService.requestVerification(body[UserField.email]));
    });

    test("updateUser", () async {
      final tc = TestContext();

      final Map<String, dynamic> map = {
        GenericField.id: tc.user.id,
        UserField.firstName: tc.user.firstName,
        UserField.lastName: tc.user.lastName,
      };

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UsersRepository.update()
      when(
        () => mockUsersRepository.update(
          id: map[GenericField.id],
          body: {
            UserField.firstName: map[UserField.firstName],
            UserField.lastName: map[UserField.lastName],
          }
        )
      ).thenAnswer(
        (_) async => (tc.getUserRecordModel(), {})
      );

      // Check record is not null and errors is empty
      final (record, errors) = await updateUser(map);
      expect(record, isNotNull);
      expect(errors.isEmpty, true);

      // UsersRepository.update(), Now returns null record and non-empty errorsMap
      when(
        () => mockUsersRepository.update(
          id: map[GenericField.id],
          body: {
            UserField.firstName: map[UserField.firstName],
            UserField.lastName: map[UserField.lastName],
          }
        )
      ).thenAnswer(
        (_) async => (null, {"ErrorField": "error message"})
      );

      // Check record2 is null and errors2 is not empty
      final (record2, errors2) = await updateUser(map);
      expect(record2, null);
      expect(errors2.isEmpty, false);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUserSettings", () async {
      final tc = TestContext();

      final Map<String, dynamic> map = {
        GenericField.id: tc.user.id,
        UserSettingsField.defaultCurrency: tc.userSettings.defaultCurrency,
        UserSettingsField.defaultInstructions: tc.userSettings.defaultInstructions,
      };

      final getIt = GetIt.instance;
      final mockUserSettingsRepository = MockUserSettingsRepository();
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository);

      // UserSettingsRepository.update()
      when(
        () => mockUserSettingsRepository.update(
          id: map[GenericField.id],
          body: {
            UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
            UserSettingsField.defaultInstructions: map[
              UserSettingsField.defaultInstructions],
          }
        )
      ).thenAnswer(
        (_) async => (tc.getUserSettingsRecordModel(), {})
      );

      // Check record is not null, and errors is empty
      final (record, errors) = await updateUserSettings(map);
      expect(record, isNotNull);
      expect(errors.isEmpty, true);

      // UserSettingsRepository.update(), Now returns null record and non-empty errorsMap
      when(
        () => mockUserSettingsRepository.update(
          id: map[GenericField.id],
          body: {
            UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
            UserSettingsField.defaultInstructions: map[
              UserSettingsField.defaultInstructions],
          }
        )
      ).thenAnswer(
        (_) async => (null, {"ErrorField": "error message"})
      );

      // Check record is null, and errors is not empty
      final (record2, errors2) = await updateUserSettings(map);
      expect(record2, null);
      expect(errors2.isEmpty, false);

    });
    tearDown(() => GetIt.instance.reset());
  });
}