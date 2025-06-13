import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("GardenTimeline test", () {
    testWidgets("snapshot.hasData", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user // For Ask.isCreatedByCurrentUser
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // mockUsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Scaffold(
              body: Column(
                children: [
                  GardenTimeline(),
                ],
              )
            )
          )
        ));

      // Check that GardenTimelineLoading is rendered first
      expect(find.byType(GardenTimelineLoading), findsOneWidget);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that GardenTimelineList is rendered next
      expect(find.byType(GardenTimelineList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("snapshot.hasError", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // mockUsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenThrow(
        Exception("an error is thrown!")
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Scaffold(
              body: Column(
                children: [
                  GardenTimeline(),
                ],
              )
            )
          )
        ));

      // Check that GardenTimelineLoading is rendered first
      expect(find.byType(GardenTimelineLoading), findsOneWidget);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that GardenTimelineError is rendered next (because of exception)
      expect(find.byType(GardenTimelineError), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}