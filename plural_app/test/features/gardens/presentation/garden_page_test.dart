import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_page.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("GardenPage test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockAuthRepository = MockAuthRepository();
      final mockGardensRepository = MockGardensRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<AppState>(() => appState);

      // AsksRepository.getAsksByGardenID()
      when(
        () => mockAsksRepository.getAsksByGardenID(
          gardenID: any(named: "gardenID"),
          count: any(named: "count"),
          filterString: any(named: "filterString")
        )
      ).thenAnswer(
        (_) async => [tc.ask]
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

      // AuthRepository.subscribeToUserSettings()
      when(
        () => mockAuthRepository.subscribeToUserSettings(any())
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
          home: GardenPage()
        ));

      // Check widgets all rendered
      expect(find.byType(GardenHeader), findsOneWidget);
      expect(find.byType(GardenTimeline), findsOneWidget);
      expect(find.byType(GardenFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}