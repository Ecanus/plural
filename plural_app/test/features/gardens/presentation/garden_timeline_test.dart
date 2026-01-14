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
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';
import '../../../test_stubs/asks_api_stubs.dart';

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
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
      );
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentUser = user // For Ask.isCreatedByCurrentUser
        ..currentUserGardenRecord = userGardenRecord
        ..currentUserSettings = userSettings;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
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
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
      );
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentUser = user // For Ask.isCreatedByCurrentUser
        ..currentUserGardenRecord = userGardenRecord
        ..currentUserSettings = userSettings;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: []),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
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
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
      );

      final appState = AppState.skipSubscribe()
        ..currentUser = user
        ..currentUserGardenRecord = userGardenRecord;

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
        (_) async => ResultList<RecordModel>(items: [
          getAskRecordModel(ask: AskFactory(creator: user))
        ])
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