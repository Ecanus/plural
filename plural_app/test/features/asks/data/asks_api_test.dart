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
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("asks_api", () {
    test("addSponsor", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      const existingUserID = "EXISTINGUSERID";
      final recordModel = tc.getAskRecordModel(sponsors: [existingUserID]);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: any(named: "id"), body: any(named: "body"))
      ).thenAnswer(
        (_) async => (recordModel, {})
      );

      // Existing ID, update() not called
      await addSponsor("", "EXISTINGUSERID");
      verifyNever(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body")));

      // New ID, update() called
      await addSponsor("", "NEWUSERID");
      verify(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body"))).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("checkBoonCeiling", () async {
      // boon == targetSum, raise error
      expect(
        () => checkBoonCeiling(100, 100),
        throwsA(
          predicate(
            (e) => e is ClientException
            && e.response[dataKey][AskField.boon][messageKey] == AppFormText.invalidBoonValue
          )
        )
      );

      // boon > targetSum, raise error
      expect(
        () => checkBoonCeiling(500, 100),
        throwsA(
          predicate(
            (e) => e is ClientException
            && e.response[dataKey][AskField.boon][messageKey] == AppFormText.invalidBoonValue
          )
        )
      );

      // boon < targetSum, no error
      expect(() => checkBoonCeiling(50, 100), returnsNormally);
    });

    ft.testWidgets("deleteAsk isAdminPage", (tester) async {
      final tc = TestContext();

      // GetIt
      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.deleteMemberAsks])
      ).thenAnswer(
        (_) async => {}
      );

      // AsksRepository.delete()
      when(
        () => mockAsksRepository.delete(id: tc.ask.id)
      ).thenAnswer(
        (_) async => (true, {})
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
                    onPressed: () => deleteAsk(context, tc.ask.id, isAdminPage: true),
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

      // Check no method calls yet; no UnauthorizedPage found
      verifyNever(() => mockAppState.verify([AppUserGardenPermission.deleteMemberAsks]));
      verifyNever(() => mockAsksRepository.delete(id: tc.ask.id));
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call deleteAsk)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods called; still no UnauthorizedPage found
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.deleteMemberAsks])).called(1);
      verify(() => mockAsksRepository.delete(id: tc.ask.id)).called(1);
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("deleteAsk !isAdminPage", (tester) async {
      final tc = TestContext();

      // GetIt
      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createAndEditAsks])
      ).thenAnswer(
        (_) async => {}
      );

      // AsksRepository.delete()
      when(
        () => mockAsksRepository.delete(id: tc.ask.id)
      ).thenAnswer(
        (_) async => (true, {})
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
                    onPressed: () => deleteAsk(context, tc.ask.id, isAdminPage: false),
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

      // Check no method calls yet; no UnauthorizedPage found
      verifyNever(() => mockAppState.verify([AppUserGardenPermission.createAndEditAsks]));
      verifyNever(() => mockAsksRepository.delete(id: tc.ask.id));
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call deleteAsk)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods called; still no UnauthorizedPage found
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.createAndEditAsks])).called(1);
      verify(() => mockAsksRepository.delete(id: tc.ask.id)).called(1);
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("deleteAsk PermissionException", (tester) async {
      final tc = TestContext();

      // GetIt
      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.deleteMemberAsks])
      ).thenThrow(
        PermissionException()
      );

      // AsksRepository.delete()
      when(
        () => mockAsksRepository.delete(id: tc.ask.id)
      ).thenAnswer(
        (_) async => (true, {})
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
                    onPressed: () => deleteAsk(context, tc.ask.id, isAdminPage: true),
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

      // Check no method calls yet; no UnauthorizedPage found
      verifyNever(() => mockAppState.verify([AppUserGardenPermission.deleteMemberAsks]));
      verifyNever(() => mockAsksRepository.delete(id: tc.ask.id));
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call deleteAsk)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods called; still no UnauthorizedPage found
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.deleteMemberAsks])).called(1);
      verifyNever(() => mockAsksRepository.delete(id: tc.ask.id));
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    test("deleteCurrentUserAsks", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      final resultList = ResultList<RecordModel>(items: [tc.getAskRecordModel()]);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => resultList
      );
      // mockAsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(resultList: resultList)
      ).thenAnswer(
        (_) async => {}
      );

      // Check no calls made yet
      verifyNever(() => mockAsksRepository.getList(filter: any(named: "filter")));
      verifyNever(() => mockAsksRepository.bulkDelete(resultList: resultList));

      await deleteCurrentUserAsks();

      // Check calls were made
      verify(() => mockAsksRepository.getList(filter: any(named: "filter"))).called(1);
      verify(() => mockAsksRepository.bulkDelete(resultList: resultList)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksByGardenID", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
        ])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // No count. Returns resultList.length
      final asksList1 = await getAsksByGardenID(gardenID: "");
      expect(asksList1.length, 3);
      expect(asksList1.first, isA<Ask>());

      // count == 2. Returns 2
      final asksList2 = await getAsksByGardenID(gardenID: "", count: 2);
      expect(asksList2.length, 2);

      // count > resultList.length. Returns resultList.length
      final asksList3 = await getAsksByGardenID(gardenID: "", count: 7);
      expect(asksList3.length, 3);
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksByUserID", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getAskRecordModel(),
          tc.getAskRecordModel(),
        ])
      );

      // mockUsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var asksList = await getAsksByUserID(userID: "");

      expect(asksList.length, 2);
      expect(asksList.first, isA<Ask>());
    });

    tearDown(() => GetIt.instance.reset());

    test("getAsksForListedAsksDialog", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      final nowString = DateFormat(Formats.dateYMMddHHms).format(DateTime.now());

      final filterString =  """
        ${AskField.creator} = '${appState.currentUser!.id}' &&
        ${AskField.garden} = '${appState.currentGarden!.id}'
        """.trim();

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: filterString,
          sort: GenericField.created,
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getAskRecordModel(
            id: "ASK001",
            targetMetDate: null,
            deadlineDate: DateTime.now().add(Duration(days: 50))),
          tc.getAskRecordModel(
            id: "ASK002",
            targetMetDate: null,
            deadlineDate: DateTime.now().add(Duration(days: -50))),
          tc.getAskRecordModel(
            id: "ASK003",
            targetMetDate: DateTime.now(),
            deadlineDate: DateTime.now().add(Duration(days: 50))),
        ])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel(
          id: tc.user.id,
          firstName: tc.user.firstName,
          lastName: tc.user.lastName,
          username: tc.user.username
        )
      );

      final asks = await getAsksForListedAsksDialog(
        userID: tc.user.id, now: DateTime.parse(nowString)
      );

      // Check length and order is correct
      expect(asks.length, 3);
      expect(asks[0].id, "ASK001");
      expect(asks[1].id, "ASK002");
      expect(asks[2].id, "ASK003");
    });

    tearDown(() => GetIt.instance.reset());

    test("getAskTypeFromString", () async {
      expect(getAskTypeFromString("monetary"), AskType.monetary);

      // Check that fallback value is monetary (for now)
      expect(getAskTypeFromString("invalidValue"), AskType.monetary);
    });

    test("getParsedTargetMetDate", () async {
      // Check returns null if empty string given
      final parsedDateTime1 = getParsedTargetMetDate("");
      expect(parsedDateTime1, null);

      final parsedDateTime2 = getParsedTargetMetDate("1995-06-13");
      expect(parsedDateTime2, DateTime(1995, 06, 13));
    });

    ft.testWidgets("isSponsoredToggle", (tester) async {
      final testList = [1, 2, 3];
      void testFunc(value) => testList.clear();

      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      final recordModel = tc.getAskRecordModel();

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
            filter: "${GenericField.id} = '${tc.ask.id}'"
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: tc.ask.id, body: { AskField.sponsors: [tc.user.id]})
      ).thenAnswer(
        (_) async => (recordModel, {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => isSponsoredToggle(
                    context, tc.ask.id, testFunc, value: false),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check no snackBar and testList still has contents
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(testList.isEmpty, false);

      // Tap ElevatedButton (to call isSponsoredToggle)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check still no snackBar; testList now empty
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(testList.isEmpty, true);

       // Value now true
       testList.addAll([1, 2, 3]);

       await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => isSponsoredToggle(
                    context, tc.ask.id, testFunc, value: true),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check no snackBar yet and testList still has contents
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(testList.isEmpty, false);

      // Tap ElevatedButton (to call isSponsoredToggle)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check snackBar now shows; testList now empty
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);
      expect(testList.isEmpty, true);

    });
    test("removeSponsor", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      const existingUserID = "EXISTINGUSERID";
      final recordModel = tc.getAskRecordModel(sponsors: [existingUserID]);

      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [recordModel])
      );

      // mockAsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: any(named: "id"), body: any(named: "body"))
      ).thenAnswer(
        (_) async => (recordModel, {})
      );

      // Existing ID, update() called
      await removeSponsor("", "EXISTINGUSERID");
      verify(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body"))).called(1);

      // New ID, update() not called
      await removeSponsor("", "NEWUSERID");
      verifyNever(() => mockAsksRepository.update(
        id: any(named: "id"), body: any(named: "body")));
    });

    tearDown(() => GetIt.instance.reset());
  });
}