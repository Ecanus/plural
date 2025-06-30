import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("ListedGardenTile test", () {
    testWidgets("LandingPageListedGardenTile", (tester) async {
      final tc = TestContext();

      final appState = AppState()
                        ..currentGarden = null
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.unsubscribe()
      when(
        () => mockAsksRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );
      // AsksRepository.subscribe()
      when(
        () => mockAsksRepository.subscribe(any(), any())
      ).thenAnswer(
        (_) async => () {}
      );

      // GardensRepository.unsubscribe()
      when(
        () => mockGardensRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );
      // GardensRepository.subscribe()
      when(
        () => mockGardensRepository.subscribe(any())
      ).thenAnswer(
        (_) async => () {}
      );

      // UsersRepository.unsubscribe()
      when(
        () => mockUsersRepository.unsubscribe()
      ).thenAnswer(
        (_) async => {}
      );
      // UsersRepository.subscribe()
      when(
        () => mockUsersRepository.subscribe(any(), any())
      ).thenAnswer(
        (_) async => () {}
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: any(named: "sort")
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getUserGardenRecordRecordModel()]
        )
      );

      // GardensRepository.getFirstListItem()
      when(
        () => mockGardensRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.garden.id}'"
          )
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel()
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'"
          )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var testRouter = GoRouter(
        initialLocation: "/test_landing_tile",
        routes: [
          GoRoute(
            path: Routes.garden,
            builder: (_, __) => SizedBox()
          ),
          GoRoute(
            path: "/test_landing_tile",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return LandingPageListedGardenTile(garden: tc.garden);
                }
              ),
            )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check title is rendered; appState.currentGarden is null
      expect(find.text(tc.garden.name), findsOneWidget);
      expect(appState.currentGarden, null);

      // Tap on the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Check appState.currentGarden has updated
      expect(appState.currentGarden, tc.garden);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("no UserGardenRecord found", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = null
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: any(named: "sort")
          )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: []
        )
      );

      var testRouter = GoRouter(
        initialLocation: "/test_landing_tile",
        routes: [
          GoRoute(
            path: Routes.garden,
            builder: (_, __) => SizedBox()
          ),
          GoRoute(
            path: "/test_landing_tile",
            builder: (_, __) => Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return LandingPageListedGardenTile(garden: tc.garden);
              }
            ),
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check title is rendered; appState.currentGarden is null
      expect(find.text(tc.garden.name), findsOneWidget);
      expect(appState.currentGarden, null);
      expect(find.byType(SnackBar), findsNothing);

      // Tap on the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Check appState.currentGarden still null, Snackbar appears
      expect(appState.currentGarden, null);
      //expect(find.byType(SnackBar), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

  });
}