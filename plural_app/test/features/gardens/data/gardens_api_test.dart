import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_widgets.dart';

void main() {
  group("Gardens api test", () {
    test("getGardenByID", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // GardensRepository.getFirstListItem()
      when(
        () => mockGardensRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel(
          creatorID: tc.user.id,
          id: tc.garden.id,
          name: "TestGarden"
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final garden = await getGardenByID(tc.garden.id);
      expect(garden, isA<Garden>());
      expect(garden.creator, tc.user);
      expect(garden.id, tc.garden.id);
      expect(garden.name, "TestGarden");

    });

    test("getGardensByUserID !excludeCurrentGarden", () async {
      final tc = TestContext();
      var appState = AppState.skipSubscribe()
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden]),
            tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden]),
            tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden]),
          ]
        )
      );

      // getGardensByUser
      List<Garden> gardens = await getGardensByUserID(
        tc.user.id, excludesCurrentGarden: false
      );

      // Check that 3 gardens created
      expect(gardens.length, 3);

      // Check that the correct filter was used
      verify(() => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("getGardensByUserID excludeCurrentGarden", () async {
      final tc = TestContext();
      var appState = AppState.skipSubscribe()
        ..currentUser = tc.user
        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: ""
            "${UserGardenRecordField.garden}.${GenericField.id} != '${tc.garden.id}' && "
            "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden]),
            tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden]),
            tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden]),
          ]
        )
      );

      // getGardensByUser
      List<Garden> gardens = await getGardensByUserID(
        tc.user.id, excludesCurrentGarden: true
      );

      // Check 3 gardens created
      expect(gardens.length, 3);

      // Check that the correct filter was used
      verify(() => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: ""
            "${UserGardenRecordField.garden}.${GenericField.id} != '${tc.garden.id}' && "
            "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("removeUserFromGarden", () async {
      final testList = ["a", "b"];

      void testFunc() {
        testList.clear();
      }

      final tc = TestContext();

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      getIt.registerLazySingleton<AsksRepository>(() => AsksRepository(pb: pb));
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => UserGardenRecordsRepository(pb: pb));

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList() - AsksRepository
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );
      // RecordService.getFirstListItem() - UserGardenRecordsRepository
      when(
        () => recordService.getFirstListItem(any())
      ).thenAnswer(
        (_) async => tc.getUserGardenRecordRecordModel()
      );
      // RecordService.delete() - AsksRepository & UserGardenRecordsRepository
      when(
        () => recordService.delete(any())
      ).thenAnswer(
        (_) async => {}
      );

      // Check testList still has values (function not yet called)
      expect(testList.isEmpty, false);

      // Check database methods not yet called
      verifyNever(() =>  recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      );
      verifyNever(() => recordService.getFirstListItem(any()));
      verifyNever(() => recordService.delete(any()));

      await removeUserFromGarden(tc.user.id, tc.garden.id, testFunc);

      // Check testList no longer has values (function called)
      expect(testList.isEmpty, true);

      // Check database methods each called
      verify(() =>  recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).called(1);
      verify(() => recordService.getFirstListItem(any())).called(1);
      verify(() => recordService.delete(any())).called(2); // 1 for Ask, 1 for UserGardenRecord
    });

    tearDown(() => GetIt.instance.reset());


    ft.testWidgets("rerouteToLandingPageWithExitedGardenID", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      var testRouter = GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => TestContextDependantFunctionWidget(
              callback: rerouteToLandingPageWithExitedGardenID
            )
          ),
          GoRoute(
            path: Routes.landing,
            builder: (_, state) => BlankPage(
              widget: Text(
                "exitedGardenID is: "
                "${state.uri.queryParameters[QueryParameters.exitedGardenID]}")
              )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check not yet redirected (Text does not render)
      expect(ft.find.text("exitedGardenID is: ${tc.garden.id}"), ft.findsNothing);

      // Tap ElevatedButton (to call rerouteToLandingAndPrepareGardenExit)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check redirected (Text should now appear)
      expect(ft.find.text("exitedGardenID is: ${tc.garden.id}"), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

  });
}