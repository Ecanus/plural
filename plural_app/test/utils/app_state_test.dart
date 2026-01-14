import 'package:flutter_test/flutter_test.dart' as ft;
import '../test_stubs/users_repository_stubs.dart' as users_repository;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';
import 'package:plural_app/src/constants/query_parameters.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Tests
import '../test_factories.dart';
import '../test_mocks.dart';
import '../test_record_models.dart';
import '../test_stubs/asks_api_stubs.dart';

void main() {
  group("AppState", () {
    test("clearUserGardenRecordAndSubscriptions", () async {
      final appState = AppState.skipSubscribe();

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<PocketBase>(() => pb);

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

      await appState.clearUserGardenRecordAndSubscriptions();

      verify(() => recordService.unsubscribe()).called(4);
    });

    test("getTimelineAsks", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);
      final userSettings = AppUserSettingsFactory(user: user);

      final ask = AskFactory(
        boon: 15,
        creator: user,
        creationDate: DateTime(1995, 6, 13),
        currency: "GHS",
        deadlineDate: DateTime(1995, 7, 24),
        description: "Test description",
        id: "test-getTimelineAsks-ask",
        instructions: "Test instructions",
        targetMetDate: null,
        targetSum: 160,
      );

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user
        ..currentUserSettings = userSettings;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: [
          getAskRecordModel(ask: ask)
        ]),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
      );

      // BuildContext.mounted
      when(
        () => mockBuildContext.mounted
      ).thenAnswer(
        (_) => true
      );

      final asks = await appState.getTimelineAsks(mockBuildContext, isAdminPage: false);
      expect(asks.length, 1);

      final firstAsk = asks.first;
      expect(firstAsk, isA<Ask>());
      expect(firstAsk.id, "test-getTimelineAsks-ask");
      expect(firstAsk.boon, 15);
      expect(firstAsk.creator, user);
      expect(firstAsk.creationDate, DateTime(1995, 6, 13));
      expect(firstAsk.currency, "GHS");
      expect(firstAsk.deadlineDate, DateTime(1995, 7, 24));
      expect(firstAsk.description, "Test description");
      expect(firstAsk.instructions, "Test instructions");
      expect(firstAsk.sponsorIDS.isEmpty, true);
      expect(firstAsk.targetMetDate, null);
      expect(firstAsk.targetSum, 160);
      expect(firstAsk.type, AskType.monetary);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("getTimelineAsks PermissionException", (tester) async {
      final user = AppUserFactory();

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = null // null currentUserGardenRecord will throw PermissionException
        ..currentUser = user;

      final testRouter = GoRouter(
        initialLocation: "/test",
        routes: [
          GoRoute(
            path: "/test",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => appState.getTimelineAsks(context, isAdminPage: true),
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

      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call getTimelineAsks)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should be redirected to UnauthorizedPage
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);
    });

    test("refreshTimelineAsks", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user
        ..currentUserSettings = userSettings;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockBuildContext = MockBuildContext();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: [
          getAskRecordModel(ask: AskFactory(creator: user))
        ]),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
      );

      // BuildContext.mounted
      when(
        () => mockBuildContext.mounted
      ).thenAnswer(
        (_) => true
      );

      final asks = await appState.getTimelineAsks(mockBuildContext);
      expect(asks.length, 1);

      // refreshTimelineAsks() should clear AppState._timelineAsks
      // (update shouldn't occur though because nothing to notify)
      appState.refreshTimelineAsks();
      expect(asks.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("setUserGardenRecordAndReroute", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = null
        ..currentUser = user;

      final mockBuildContext = MockBuildContext();
      final mockGoRouter = MockGoRouter();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList(). Return empty list at first.
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: any(named: "sort")
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: []
        )
      );

      // UsersRepository.getFirstListItem()
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden.creator.id,
        returnValue: getUserRecordModel(user: garden.creator)
      );

      // BuildContext.mounted
      when(
        () => mockBuildContext.mounted
      ).thenReturn(
        true
      );

      // Check currentUserGardenRecord is null
      expect(appState.currentUserGardenRecord, null);

      // Check methods not yet called
      verifyNever(() => mockBuildContext.mounted);

      await appState.setUserGardenRecordAndReroute(
        mockBuildContext,
        garden,
        goRouter: mockGoRouter
      );

      // Check currentGarden is still null (was never set because no userGardenRecord was found)
      expect(appState.currentUserGardenRecord, null);

      // Check methods were called
      verify(() => mockBuildContext.mounted).called(1);

      // UserGardenRecordsRepository.getList(), now returns RecordModel
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: any(named: "sort")
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: userGardenRecord,
              expandFields: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ],
            ),
          ]
        )
      );

      // GoRouter.go()
      when(
        () => mockGoRouter.go(Routes.garden)
      ).thenReturn(null);

      // Check currentGarden is null (call not yet made)
      expect(appState.currentUserGardenRecord, null);

      // Check methods not yet called
      verifyNever(() => mockBuildContext.mounted);
      verifyNever(() => mockGoRouter.go(Routes.garden));

      await appState.setUserGardenRecordAndReroute(
        mockBuildContext, garden, goRouter: mockGoRouter);

      // Check curerentGarden is now set
      expect(appState.currentUserGardenRecord, userGardenRecord);

      // Check methods were called
      verify(() => mockBuildContext.mounted).called(1);
      verify(() => mockGoRouter.go(Routes.garden)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("isAdministrator, isOwner", () async {
      final user = AppUserFactory();

      final userGardenRecordMember = AppUserGardenRecordFactory(
        user: user, role:
        AppUserGardenRole.member
      );
      final userGardenRecordAdmin = AppUserGardenRecordFactory(
        user: user,
        role: AppUserGardenRole.administrator
      );
      final userGardenRecordOwner = AppUserGardenRecordFactory(
        user: user,
        role: AppUserGardenRole.owner
      );

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecordMember
        ..currentUser = user;

      // currentUserGardenRecord has role of "member"
      expect(appState.isAdministrator(), false);
      expect(appState.isOwner(), false);

      // currentUserGardenRecord has role of "administrator"
      appState.currentUserGardenRecord = userGardenRecordAdmin;
      expect(appState.isAdministrator(), true);
      expect(appState.isOwner(), false);

      // currentUserGardenRecord has role of "owner"
      appState.currentUserGardenRecord = userGardenRecordOwner;
      expect(appState.isAdministrator(), true);
      expect(appState.isOwner(), true);
    });

    test("verify", () async {
      final user = AppUserFactory();

      final userGardenRecordMember = AppUserGardenRecordFactory(
        user: user,
        role: AppUserGardenRole.member
      );

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecordMember
        ..currentUser = user;

      final ownerPermissions = [
        AppUserGardenPermission.changeOwner,
        AppUserGardenPermission.deleteGarden,
      ];

      final memberPermissions = [
        AppUserGardenPermission.createAndEditAsks,
        AppUserGardenPermission.viewGardenTimeline,
      ];

      // Check no exceptions thrown
      appState.verify(memberPermissions);

      // Check throws exception because insufficient permissions
      expect(
        () => appState.verify(ownerPermissions),
        throwsA(predicate((e) => e is PermissionException))
      );

      // currentUserGardenRecord is now null
      appState.currentUserGardenRecord = null;

      // Check throws exception because no UserGardenRecord was found (it's null)
      expect(
        () => appState.verify(ownerPermissions),
        throwsA(predicate((e) => e is PermissionException))
      );
    });

  });
}