import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("ListedGardenTile test", () {
    testWidgets("ListedGardenTile", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentGarden = null;

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final mockAsksRepository = MockAsksRepository();
      final mockAuthRepository = MockAuthRepository();
      final mockGardensRepository = MockGardensRepository();
      getIt.registerLazySingleton(() => mockAsksRepository as AsksRepository);
      getIt.registerLazySingleton(() => mockAuthRepository as AuthRepository);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<AppState>(() => appState);
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
        (_) async => () {}
      );

      // AsksRepository.subscribeTo()
      when(
        () => mockAsksRepository.subscribeTo(any(), any())
      ).thenAnswer(
        (_) async => () {}
      );
      // AuthRepository.subscribeToUsers()
      when(
        () => mockAuthRepository.subscribeToUsers(any(), any())
      ).thenAnswer(
        (_) async => () {}
      );
      // GardensRepository.subscribeTo()
      when(
        () => mockGardensRepository.subscribeTo(any())
      ).thenAnswer(
        (_) async => () {}
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ListedGardenTile(garden: tc.garden);
              }
            ),
          ),
        ));

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

    testWidgets("LandingPageListedGardenTile", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentGarden = null;

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final mockAsksRepository = MockAsksRepository();
      final mockAuthRepository = MockAuthRepository();
      final mockGardensRepository = MockGardensRepository();
      getIt.registerLazySingleton(() => mockAsksRepository as AsksRepository);
      getIt.registerLazySingleton(() => mockAuthRepository as AuthRepository);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<AppState>(() => appState);
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
        (_) async => () {}
      );

      // AsksRepository.subscribeTo()
      when(
        () => mockAsksRepository.subscribeTo(any(), any())
      ).thenAnswer(
        (_) async => () {}
      );
      // AuthRepository.subscribeToUsers()
      when(
        () => mockAuthRepository.subscribeToUsers(any(), any())
      ).thenAnswer(
        (_) async => () {}
      );
      // GardensRepository.subscribeTo()
      when(
        () => mockGardensRepository.subscribeTo(any())
      ).thenAnswer(
        (_) async => () {}
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

  });
}