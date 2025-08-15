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
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';
import '../../../test_stubs/users_repository_stubs.dart';
import '../../../test_widgets.dart';

void main() {
  group("gardens_api", () {
    test("getGardenByID", () async {
      final creator = AppUserFactory();
      final garden = GardenFactory(
        creator: creator,
        doDocument: "Test Do Document",
        doDocumentEditDate: DateTime(2001, 1, 3),
        id: "testGarden",
        name:"A Garden By Any Other Name"
      );

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // GardensRepository.getFirstListItem()
      when(
        () => mockGardensRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => getGardenRecordModel(garden: garden)
      );

      // UsersRepository.getFirstListItem()
      getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden.creator.id,
        returnValue: getUserRecordModel(user: garden.creator)
      );

      final gardenByID = await getGardenByID(garden.id);
      expect(gardenByID, isA<Garden>());
      expect(gardenByID.creator, creator);
      expect(gardenByID.doDocument, "Test Do Document");
      expect(gardenByID.doDocumentEditDate, DateTime.parse("2001-01-03 00:00:00"));
      expect(gardenByID.id, garden.id);
      expect(gardenByID.name, "A Garden By Any Other Name");

    });

    test("removeUserFromGarden", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final testList = ["a", "b"];
      void testFunc() => testList.clear();

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
        (_) async => ResultList<RecordModel>(
          items: [
            getAskRecordModel(ask: AskFactory(creator: user))
          ]
        )
      );
      // RecordService.getFirstListItem() - UserGardenRecordsRepository
      when(
        () => recordService.getFirstListItem(any())
      ).thenAnswer(
        (_) async => getUserGardenRecordRecordModel(
          userGardenRecord: AppUserGardenRecordFactory(
            garden: garden,
            user: user
          )
        )
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

      await removeUserFromGarden(user.id, garden.id, testFunc);

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
      final garden = GardenFactory();

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden;

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
      expect(ft.find.text("exitedGardenID is: ${garden.id}"), ft.findsNothing);

      // Tap ElevatedButton (to call rerouteToLandingAndPrepareGardenExit)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check redirected (Text should now appear)
      expect(ft.find.text("exitedGardenID is: ${garden.id}"), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    test("subscribeTo", () async {
      final garden = GardenFactory();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();

      getIt.registerLazySingleton<GardensRepository>(
        () => mockGardensRepository
      );

      // UsersRepository.unsubscribe()
      when(
        () => mockGardensRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );

      // UsersRepository.subscribe()
      when(
        () => mockGardensRepository.subscribe(garden.id)
      ).thenAnswer(
        (_) async => () {}
      );

      verifyNever(() => mockGardensRepository.unsubscribe());
      verifyNever(() => mockGardensRepository.subscribe(garden.id)
      );

      await subscribeTo(garden.id);

      verify(() => mockGardensRepository.unsubscribe()).called(1);
      verify(() => mockGardensRepository.subscribe(garden.id)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("updateGarden", (tester) async {
      final Map<String, String> map = {
        GardenField.doDocument: "test Do Document",
        GenericField.id: "testGardenID",
        GardenField.name: "newGardenName",
      };

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockGardensRepository = MockGardensRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([
          AppUserGardenPermission.changeGardenName,
          AppUserGardenPermission.editDoDocument,
        ])
      ).thenAnswer(
        (_) async => {}
      );

      // GardensRepository.update()
      gardensRepositoryUpdateStub(
        mockGardensRepository: mockGardensRepository,
        gardenID: map[GenericField.id]!,
        gardenName: map[GardenField.name]!,
        gardenDoDocument: map[GardenField.doDocument]!,
        gardenDoDocumentEditDate: DateTime.now(), // has to be DateTime.now()
        returnValue: (getGardenRecordModel(), {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => updateGarden(context, map),
                  child: Text("The ElevatedButton")
                );
              }
            )
          )
        )
      );

      // Check verify() and update() not yet called
      verifyNever(() => mockAppState.verify(any()));
      verifyNever(() => mockGardensRepository.update(
        id: map[GenericField.id]!,
        body: {
          GardenField.doDocument: map[GardenField.doDocument],
          GardenField.doDocumentEditDate:
            DateFormat(Formats.dateYMMddHHm).format(DateTime.now()),
          GardenField.name: map[GardenField.name]
        }
      ));

      // Tap button (to call expelUserFromGarden)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check both verify() and update() are called
      verify(() => mockAppState.verify(any())).called(1);
      verify(() => mockGardensRepository.update(
        id: map[GenericField.id]!,
        body: {
          GardenField.doDocument: map[GardenField.doDocument],
          GardenField.doDocumentEditDate:
            DateFormat(Formats.dateYMMddHHm).format(DateTime.now()),
          GardenField.name: map[GardenField.name]
        }
      )).called(1);

    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("updateGardenName PermissionException", (tester) async {
      final Map<String, String> map = {
        GardenField.doDocument: "test Do Document",
        GenericField.id: "testGardenID",
        GardenField.name: "newGardenName",
      };

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockGardensRepository = MockGardensRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([
          AppUserGardenPermission.changeGardenName,
          AppUserGardenPermission.editDoDocument,
        ])
      ).thenThrow(
        PermissionException()
      );

      // GardensRepository.update()
      gardensRepositoryUpdateStub(
        mockGardensRepository: mockGardensRepository,
        gardenID: map[GenericField.id]!,
        gardenDoDocument: map[GardenField.doDocument]!,
        gardenDoDocumentEditDate: DateTime.now(), // must be DateTime.now()
        gardenName: map[GardenField.name]!,
        returnValue: (getGardenRecordModel(), {})
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
                    onPressed: () => updateGarden(context, map),
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

      // Check verify() and update() not yet called; no UnauthorizedPage() widget
      verifyNever(() => mockAppState.verify(any()));
      verifyNever(() => mockGardensRepository.update(
        id: map[GenericField.id]!,
        body: {
          GardenField.doDocument: map[GardenField.doDocument],
          GardenField.doDocumentEditDate:
            DateFormat(Formats.dateYMMddHHm).format(DateTime.now()),
          GardenField.name: map[GardenField.name]
        }
      ));
      expect(ft.find.byType(UnauthorizedPage), ft.findsNothing);

      // Tap button (to call expelUserFromGarden)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check only verify() is called. UnauthorizedPage() widget is found
      verify(() => mockAppState.verify(any())).called(1);
      verifyNever(() => mockGardensRepository.update(
        id: map[GenericField.id]!,
        body: {
          GardenField.name: map[GardenField.name]
        }
      ));
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);

    });

    tearDown(() => GetIt.instance.reset());

  });
}