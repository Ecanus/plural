import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("GardenTimeline", () {
    testWidgets("emptyTimelineMessage", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: EmptyTimelineMessage(),
          ),
        )
      );

      expect(find.byIcon(Icons.emoji_food_beverage), findsOneWidget);
      expect(find.text(GardenTimelineText.emptyTimelineMessage), findsOneWidget);
      expect(find.text(GardenTimelineText.emptyTimelineSubtitle), findsOneWidget);
    });

    testWidgets("snapshot.hasData", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user // For Ask.isCreatedByCurrentUser
                        ..currentGarden = tc.garden
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // Stubs
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: ResultList<RecordModel>(items: [tc.getUserGardenRecordRecordModel()])
      );
      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: [tc.getAskRecordModel()]),
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        usersReturnValue: tc.getUserRecordModel(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      GardenTimeline(),
                    ],
                  );
                }
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

    testWidgets("snapshot.hasData empty", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user // For Ask.isCreatedByCurrentUser
                        ..currentGarden = tc.garden
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // Stubs
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: ResultList<RecordModel>(items: [tc.getUserGardenRecordRecordModel()])
      );
      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: []),
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        usersReturnValue: tc.getUserRecordModel(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      GardenTimeline(),
                    ],
                  );
                }
              )
            )
          )
        ));

      // Check that GardenTimelineLoading is rendered first
      expect(find.byType(GardenTimelineLoading), findsOneWidget);
      expect(find.byType(GardenTimelineTile), findsNothing);
      expect(find.byType(EmptyTimelineMessage), findsNothing);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that GardenTimelineList is not rendered. EmptyTimelineMessage is rendered
      expect(find.byType(GardenTimelineLoading), findsNothing);
      expect(find.byType(GardenTimelineTile), findsNothing);
      expect(find.byType(EmptyTimelineMessage), findsOneWidget);
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
      expect(find.byType(GardenTimelineError), findsNothing);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that GardenTimelineError is rendered next (because of exception)
      expect(find.byType(GardenTimelineLoading), findsNothing);
      expect(find.byType(GardenTimelineError), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}