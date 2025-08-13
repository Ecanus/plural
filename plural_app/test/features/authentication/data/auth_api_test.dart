import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

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
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("auth_api", () {
    ft.testWidgets("deleteCurrentUserAccount", (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => deleteCurrentUserAccount(context: context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          )
        )
      );

      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap button (to call expelUserFromGarden)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check after that delete methods never called
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: asksResultList));
      verifyNever(() => mockUserGardenRecordsRepository.bulkDelete(
        resultList: userGardenRecordsResultList)
      );
      verifyNever(() => mockUserSettingsRepository.delete(id: tc.userSettings.id));
      verifyNever(() => mockUsersRepository.delete(id: tc.user.id));
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);
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

    ft.testWidgets("expelUserFromGarden", (tester) async {
      final list = [1, 2, 3];
      void testCallback(BuildContext context) => list.clear();

      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockAsksRepository = MockAsksRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // AppState.verify()
      when(
        () => mockAppState.verify(any())
      ).thenAnswer(
        (_) async => {}
      );

      // AsksRepository.getList()
      final resultList = ResultList<RecordModel>(items: [tc.getAskRecordModel()]);
      when(
        () => mockAsksRepository.getList(
          filter: ""
          "${AskField.creator} = '${tc.user.id}'"
          "&& ${AskField.garden} = '${tc.garden.id}'"
        )
      ).thenAnswer(
        (_) async => resultList
      );

      // AsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(resultList: resultList)
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.delete()
      when(
        () => mockUserGardenRecordsRepository.delete(id: tc.userGardenRecord.id)
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => expelUserFromGarden(
                    context,
                    tc.userGardenRecord,
                    callback: testCallback),
                  child: Text("The ElevatedButton")
                );
              }
            )
          )
        )
      );

      // check verify() and delete() not yet called; testCallback not called
      // can't test SnackBar due to Navigator.pop
      expect(list.isEmpty, false);
      verifyNever(() => mockAppState.verify(any()));
      verifyNever(() => mockUserGardenRecordsRepository.delete(
        id: tc.userGardenRecord.id)
      );

      // Tap button (to call expelUserFromGarden)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // check verify() and delete() now called; testCallback called
      // can't test SnackBar due to Navigator.pop
      expect(list.isEmpty, true);
      verify(() => mockAppState.verify(any())).called(1);
      verify(() => mockUserGardenRecordsRepository.delete(
        id: tc.userGardenRecord.id)
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("expelUserFromGarden PermissionException", (tester) async {
      final list = [1, 2, 3];
      void testCallback(BuildContext context) => list.clear();

      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockAsksRepository = MockAsksRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // AppState.verify()
      when(
        () => mockAppState.verify(any())
      ).thenThrow(
        PermissionException()
      );

      // AsksRepository.getList()
      final resultList = ResultList<RecordModel>(items: [tc.getAskRecordModel()]);
      when(
        () => mockAsksRepository.getList(
          filter: ""
          "${AskField.creator} = '${tc.user.id}'"
          "&& ${AskField.garden} = '${tc.garden.id}'"
        )
      ).thenAnswer(
        (_) async => resultList
      );

      // AsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(resultList: resultList)
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.delete()
      when(
        () => mockUserGardenRecordsRepository.delete(id: tc.userGardenRecord.id)
      ).thenAnswer(
        (_) async => {}
      );

      final testRouter = GoRouter(
        initialLocation: "/test",
        routes: [
          GoRoute(
            path: "/test",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => expelUserFromGarden(
                      context,
                      tc.userGardenRecord,
                      callback: testCallback),
                    child: Text("The ElevatedButton")
                  );
                }
              )
            )
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, state) => UnauthorizedPage(
            previousRoute: state.uri.queryParameters[QueryParameters.previousRoute],
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // check verify() testCallback, and delete() not yet called
      expect(list.isEmpty, false);
      verifyNever(() => mockAppState.verify(any()));
      verifyNever(() => mockAsksRepository.getList(
          filter: ""
          "${AskField.creator} = '${tc.user.id}'"
          "&& ${AskField.garden} = '${tc.garden.id}'"
        ));
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: resultList));
      verifyNever(() => mockUserGardenRecordsRepository.delete(
        id: tc.userGardenRecord.id)
      );
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call expelUserFromGarden)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // check only verify() is called; check successful redirect
      expect(list.isEmpty, false);
      verify(() => mockAppState.verify(any())).called(1);
      verifyNever(() => mockAsksRepository.getList(
          filter: ""
          "${AskField.creator} = '${tc.user.id}'"
          "&& ${AskField.garden} = '${tc.garden.id}'"
        ));
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: resultList));
      verifyNever(() => mockUserGardenRecordsRepository.delete(
        id: tc.userGardenRecord.id)
      );
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    test("getCurrentGardenUserGardenRecords", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // getUserGardenRecordRole()
      final items = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: items
      );

      // getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(
        items: [
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
            role: AppUserGardenRole.owner
          ),
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
            role: AppUserGardenRole.administrator
          ),
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
        ]
      );
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: tc.garden.id,
        returnValue: currentGardenUserGardenRecordsItems
      );

      // UsersRepository.getFirstListItem()
      usersRepositoryGetFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        returnValue: tc.getUserRecordModel()
      );

      final userGardenRecordsMap = await getCurrentGardenUserGardenRecords(
        mockBuildContext,);

      expect(userGardenRecordsMap[AppUserGardenRole.owner]!.length, 1);
      expect(userGardenRecordsMap[AppUserGardenRole.administrator]!.length, 1);
      expect(userGardenRecordsMap[AppUserGardenRole.member]!.length, 2);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("getCurrentGardenUserGardenRecords PermissionException", (tester) async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify(any())
      ).thenThrow(
        PermissionException()
      );

      // UserGardenRecordsRepository.getList(), getCurrentGardenUserGardenRecords
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ],
              role: AppUserGardenRole.owner
            ),
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ],
              role: AppUserGardenRole.administrator
            ),
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ]
            ),
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ]
            ),
          ]
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      ).thenThrow(
        (_) async => tc.getUserRecordModel()
      );

      final testRouter = GoRouter(
        initialLocation: "/test",
        routes: [
          GoRoute(
            path: "/test",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => getCurrentGardenUserGardenRecords(context,),
                    child: Text("The ElevatedButton")
                  );
                }
              )
            )
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, state) => UnauthorizedPage(
            previousRoute: state.uri.queryParameters[QueryParameters.previousRoute],
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // check verify(), getList() and getFirstListItem() not yet called
      // check no UnauthorizedPage
      verifyNever(() => mockAppState.verify(any()));
      verifyNever(() => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      );
      verifyNever(() => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      );
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call getCurrentGardenUserGardenRecords)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check only veriy() is called; check successful redirect
      verify(() => mockAppState.verify(any())).called(1);
      verifyNever(() => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      );
      verifyNever(() => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      );
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);

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
        () => mockUserSettingsRepository
      );

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
      expect(appUser.firstName, tc.user.firstName);
      expect(appUser.lastName, tc.user.lastName);
      expect(appUser.username, tc.user.username);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserGardenPermissionGroup", () async {
      // Owner permissions (mind the order)
      expect(
        getUserGardenPermissionGroup(AppUserGardenRole.owner),
        [
          AppUserGardenPermission.changeOwner, // owner only
          AppUserGardenPermission.deleteGarden, // owner only
          AppUserGardenPermission.changeGardenName,
          AppUserGardenPermission.changeMemberRoles,
          AppUserGardenPermission.createInvitations,
          AppUserGardenPermission.deleteMemberAsks,
          AppUserGardenPermission.editDoDocument,
          AppUserGardenPermission.expelMembers,
          AppUserGardenPermission.viewActiveInvitations,
          AppUserGardenPermission.viewAdminGardenTimeline,
          AppUserGardenPermission.viewAllUsers,
          AppUserGardenPermission.viewAuditLog,
          AppUserGardenPermission.createAndEditAsks,
          AppUserGardenPermission.viewGardenTimeline,
        ]
      );

      // Administrator permissions
      expect(
        getUserGardenPermissionGroup(AppUserGardenRole.administrator),
        [
          AppUserGardenPermission.changeGardenName,
          AppUserGardenPermission.changeMemberRoles,
          AppUserGardenPermission.createInvitations,
          AppUserGardenPermission.deleteMemberAsks,
          AppUserGardenPermission.editDoDocument,
          AppUserGardenPermission.expelMembers,
          AppUserGardenPermission.viewActiveInvitations,
          AppUserGardenPermission.viewAdminGardenTimeline,
          AppUserGardenPermission.viewAllUsers,
          AppUserGardenPermission.viewAuditLog,
          AppUserGardenPermission.createAndEditAsks,
          AppUserGardenPermission.viewGardenTimeline,
        ]
      );

      // Member permissions
      expect(
        getUserGardenPermissionGroup(AppUserGardenRole.member),
        [
          AppUserGardenPermission.createAndEditAsks,
          AppUserGardenPermission.viewGardenTimeline
        ]
      );
    });

    test("getUserGardenRecord", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user, UserGardenRecordField.garden
              ],
              recordID: "TestGardenRecordID",
              role: AppUserGardenRole.member),
          ]
        )
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
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
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

    test("getUserGardenRecordRole", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

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
          items: [tc.getUserGardenRecordRecordModel()]
        )
      );

      final userGardenRecordRole = await getUserGardenRecordRole(
        userID: tc.user.id,
        gardenID: tc.garden.id
      );

      expect(userGardenRecordRole!.name, AppUserGardenRole.member.name);
      expect(userGardenRecordRole.priority, AppUserGardenRole.member.priority);
      expect(userGardenRecordRole.displayName, AppUserGardenRole.member.displayName);

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

      final userGardenRecordRole2 = await getUserGardenRecordRole(
        userID: tc.user.id,
        gardenID: tc.garden.id
      );

      // Check null is now returned
      expect(userGardenRecordRole2, null);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserGardenRecordsByUserID", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: "${UserGardenRecordField.garden}.${GardenField.name}"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user, UserGardenRecordField.garden
              ],
              role: AppUserGardenRole.owner
            ),
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ],
              role: AppUserGardenRole.administrator
            ),
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ]
            ),
            tc.getUserGardenRecordRecordModel(
              expand: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ]
            ),
          ]
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final userGardenRecords = await getUserGardenRecordsByUserID(tc.user.id);

      expect (userGardenRecords.length, 4);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserGardenRoleFromString", () async {
      // name
      expect(getUserGardenRoleFromString("member"), AppUserGardenRole.member);
      expect(
        getUserGardenRoleFromString("administrator"), AppUserGardenRole.administrator);
      expect(getUserGardenRoleFromString("owner"), AppUserGardenRole.owner);

      // displayName
      expect(
        getUserGardenRoleFromString("Member", displayName: true),
        AppUserGardenRole.member
      );
      expect(
        getUserGardenRoleFromString("Administrator", displayName: true),
        AppUserGardenRole.administrator
      );
      expect(
        getUserGardenRoleFromString("Owner", displayName: true),
        AppUserGardenRole.owner
      );

      // Check that fallback value is null
      expect(getUserGardenRoleFromString("invalidValue"), null);
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

    test("subscribeToUserGardenRecords", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      void testCallback() => {};

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // UserGardenRecordsRepository.unsubscribe()
      when(
        () => mockUserGardenRecordsRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.subscribe()
      when(
        () => mockUserGardenRecordsRepository.subscribe(
          tc.garden.id, testCallback
        )
      ).thenAnswer(
        (_) async => () {}
      );

      verifyNever(() => mockUserGardenRecordsRepository.unsubscribe());
      verifyNever(() => mockUserGardenRecordsRepository.subscribe(
        tc.garden.id, testCallback)
      );

      await subscribeToUserGardenRecords(tc.garden.id, testCallback);

      verify(() => mockUserGardenRecordsRepository.unsubscribe()).called(1);
      verify(() => mockUserGardenRecordsRepository.subscribe(
        tc.garden.id, testCallback)
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("subscribeToUsers", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();

      void testCallback() => {};

      getIt.registerLazySingleton<UsersRepository>(
        () => mockUsersRepository
      );

      // UsersRepository.unsubscribe()
      when(
        () => mockUsersRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );

      // UsersRepository.subscribe()
      when(
        () => mockUsersRepository.subscribe(
          tc.garden.id, testCallback
        )
      ).thenAnswer(
        (_) async => () {}
      );

      verifyNever(() => mockUsersRepository.unsubscribe());
      verifyNever(() => mockUsersRepository.subscribe(
        tc.garden.id, testCallback)
      );

      await subscribeToUsers(tc.garden.id, testCallback);

      verify(() => mockUsersRepository.unsubscribe()).called(1);
      verify(() => mockUsersRepository.subscribe(
        tc.garden.id, testCallback)
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("subscribeToUserSettings", () async {
      final getIt = GetIt.instance;
      final mockUserSettingsRepository = MockUserSettingsRepository();

      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository
      );

      // UserSettingsRepository.unsubscribe()
      when(
        () => mockUserSettingsRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );

      // UserSettingsRepository.subscribe()
      when(
        () => mockUserSettingsRepository.subscribe()
      ).thenAnswer(
        (_) async => () {}
      );

      verifyNever(() => mockUserSettingsRepository.unsubscribe());
      verifyNever(() => mockUserSettingsRepository.subscribe());

      await subscribeToUserSettings();

      verify(() => mockUserSettingsRepository.unsubscribe()).called(1);
      verify(() => mockUserSettingsRepository.subscribe()).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUserGardenRole", () async {
      final tc = TestContext();

      final Map<dynamic, dynamic> map = {
        GenericField.id: "id",
        UserGardenRecordField.garden: tc.garden.id,
        UserGardenRecordField.role: AppUserGardenRole.administrator.name,
        UserGardenRecordField.user: tc.user.id
      };

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // Stub
      final items = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: items
      );

      final recordModel = tc.getUserGardenRecordRecordModel(
        role: AppUserGardenRole.administrator);
      userGardenRecordsRepositoryUpdateStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userGardenRecordID: map[GenericField.id],
        userGardenRoleName: map[UserGardenRecordField.role],
        returnValue: (recordModel, {})
      );

      // check nothing called yet
      verifyNever(() => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      );
      verifyNever(() => mockUserGardenRecordsRepository.update(
          id: map[GenericField.id],
          body: {
            UserGardenRecordField.role: map[UserGardenRecordField.role]
          }
        )
      );

      await updateUserGardenRole(mockBuildContext, map);

      // getList() called for getUserGardenRecordRole() and during verify() (x2)
      verify(() => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).called(2);

      verify(() => mockUserGardenRecordsRepository.update(
          id: map[GenericField.id],
          body: {
            UserGardenRecordField.role: map[UserGardenRecordField.role]
          }
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("updateUserGardenRole isChangingOwner", () async {
      final tc = TestContext();

      final otherUser = AppUser(
        firstName: "firstName",
        id: "id",
        lastName: "lastName",
        username: "username"
      );

      final Map<dynamic, dynamic> map = {
        GenericField.id: "id",
        UserGardenRecordField.garden: tc.garden.id,
        UserGardenRecordField.role: AppUserGardenRole.owner.name,
        UserGardenRecordField.user: otherUser.id
      };

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // otherUser -> getUserGardenRecordRole()
      final otherUserRecordRoleItems = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: otherUser.id,
        gardenID: tc.garden.id,
        returnValue: otherUserRecordRoleItems
      );

      // currentUser -> getUserGardenRecordRole()
      final currentUserRecordRoleItems = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.owner)
      ]);
       getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: currentUserRecordRoleItems
      );

      // otherUser -> update()
      final otherUserRecordModel = tc.getUserGardenRecordRecordModel(
        role: AppUserGardenRole.administrator);
      userGardenRecordsRepositoryUpdateStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userGardenRecordID: map[GenericField.id],
        userGardenRoleName: map[UserGardenRecordField.role],
        returnValue: (otherUserRecordModel, {}),
      );

      // currentUser -> getUserGardenRecord()
      final currentUserGardenRecordItems = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(
          expand: [
            UserGardenRecordField.user,
            UserGardenRecordField.garden
          ],
          recordID: "testRecordID",
          role: AppUserGardenRole.owner
        )
      ]);
      getUserGardenRecordStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        userGardenRecordReturnValue: currentUserGardenRecordItems,
        mockUsersRepository: mockUsersRepository,
        gardenCreatorID: tc.user.id,
        gardenCreatorReturnValue: tc.getUserRecordModel()
      );

      // currentUser -> update()
      final currentUserRecordModel = tc.getUserGardenRecordRecordModel(
        role: AppUserGardenRole.administrator);
      userGardenRecordsRepositoryUpdateStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userGardenRecordID: "testRecordID",
        userGardenRoleName: AppUserGardenRole.administrator.name,
        returnValue: (currentUserRecordModel, {}),
      );

      // check nothing called yet
      verifyNever(() => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${otherUser.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      );
      verifyNever(() => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      );
      verifyNever(() => mockUserGardenRecordsRepository.update(
          id: map[GenericField.id],
          body: {
            UserGardenRecordField.role: map[UserGardenRecordField.role]
          }
        )
      );
      verifyNever(() => mockUserGardenRecordsRepository.getList(
        expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
        filter: ""
          "${UserGardenRecordField.user} = '${tc.user.id}' && "
          "${UserGardenRecordField.garden} = '${tc.garden.id}'",
        sort: "-updated"
      ));
      verifyNever(() =>  mockUsersRepository.getFirstListItem(
        filter: "${GenericField.id} = '${tc.user.id}'"
      ));
      verifyNever(() => mockUserGardenRecordsRepository.update(
        id: "testRecordID",
        body: {
          UserGardenRecordField.role: AppUserGardenRole.administrator.name
        }
      ));

      // Call method
      await updateUserGardenRole(mockBuildContext, map);

      // check methods were called
      verify(() => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${otherUser.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).called(1);
      verify(() => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).called(1);
      verify(() => mockUserGardenRecordsRepository.update(
          id: map[GenericField.id],
          body: {
            UserGardenRecordField.role: map[UserGardenRecordField.role]
          }
        )
      ).called(1);
      verify(() => mockUserGardenRecordsRepository.getList(
        expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
        filter: ""
          "${UserGardenRecordField.user} = '${tc.user.id}' && "
          "${UserGardenRecordField.garden} = '${tc.garden.id}'",
        sort: "-updated"
      )).called(1);
      verify(() =>  mockUsersRepository.getFirstListItem(
        filter: "${GenericField.id} = '${tc.user.id}'"
      ));
      verify(() => mockUserGardenRecordsRepository.update(
        id: "testRecordID",
        body: {
          UserGardenRecordField.role: AppUserGardenRole.administrator.name
        }
      )).called(1);

    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("updateUserGardenRole PermissionException", (tester) async {
      final tc = TestContext();

      final otherUser = AppUser(
        firstName: "firstName",
        id: "id",
        lastName: "lastName",
        username: "username"
      );

      final Map<dynamic, dynamic> map = {
        GenericField.id: "id",
        UserGardenRecordField.garden: tc.garden.id,
        UserGardenRecordField.role: AppUserGardenRole.owner.name,
        UserGardenRecordField.user: otherUser.id
      };

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // otherUser -> getUserGardenRecordRole()
      final otherUserRecordRoleItems = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: otherUser.id,
        gardenID: tc.garden.id,
        returnValue: otherUserRecordRoleItems
      );

      // currentUser -> getUserGardenRecordRole()
      final currentUserRecordRoleItems = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.member)
      ]);
       getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: currentUserRecordRoleItems
      );

      // check nothing called yet


      final testRouter = GoRouter(
        initialLocation: "/test",
        routes: [
          GoRoute(
            path: "/test",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => updateUserGardenRole(context, map),
                    child: Text("The ElevatedButton")
                  );
                }
              )
            )
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, state) => UnauthorizedPage(
            previousRoute: state.uri.queryParameters[QueryParameters.previousRoute],
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check not yet in UnauthorizedPage
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call expelUserFromGarden)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check redirected to UnauthorizedPage
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

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

    test("updateCurrentUserGardenRecordDoDocumentReadDate", () async {
      final userGardenRecord = AppUserGardenRecordFactory();
      final now = DateTime.now();

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);

      // UserGardenRecordsRepository.update()
      when(
        () => mockUserGardenRecordsRepository.update(
          id: userGardenRecord.id,
          body: {
            UserGardenRecordField.doDocumentReadDate:
              DateFormat(Formats.dateYMMddHHm).format(now)
          }
        )
      ).thenAnswer(
        (_) async => (
          getUserGardenRecordRecordModel(userGardenRecord: userGardenRecord), {})
      );

      verifyNever(() => mockUserGardenRecordsRepository.update(
          id: userGardenRecord.id,
          body: {
            UserGardenRecordField.doDocumentReadDate:
              DateFormat(Formats.dateYMMddHHm).format(now)
          }
        )
      );

      await updateCurrentUserGardenRecordDoDocumentReadDate(userGardenRecord.id);

      verify(() => mockUserGardenRecordsRepository.update(
          id: userGardenRecord.id,
          body: {
            UserGardenRecordField.doDocumentReadDate:
              DateFormat(Formats.dateYMMddHHm).format(now)
          }
        )
      ).called(1);
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
            UserSettingsField.defaultInstructions:
              map[UserSettingsField.defaultInstructions],
            UserSettingsField.gardenTimelineDisplayCount:
              map[UserSettingsField.gardenTimelineDisplayCount],
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
            UserSettingsField.defaultInstructions:
              map[UserSettingsField.defaultInstructions],
            UserSettingsField.gardenTimelineDisplayCount:
              map[UserSettingsField.gardenTimelineDisplayCount],
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