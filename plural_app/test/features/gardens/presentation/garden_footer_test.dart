import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("GardenFooter test", () {
    testWidgets("_isFooterCollapsed", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GardenFooter(),
          ),
        ));

      // Check AppBottomBar not rendered
      expect(find.byType(AppBottomBar), findsNothing);

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered
      expect(find.byType(AppBottomBar), findsOneWidget);
    });

    testWidgets("createListedAsksDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
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

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(AskDialogList), findsNothing);

      // Tap IconButton with Icons.aspect_ratio (opens listed asks dialog)
      await tester.tap(find.byIcon(Icons.aspect_ratio));
      await tester.pumpAndSettle();

      expect(find.byType(AskDialogList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createUserSettingsDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; UserSettingsDialog not rendered
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(UserSettingsList), findsNothing);

      // Tap IconButton with Icons.settings (opens user settings dialog)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(UserSettingsList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createListedUsersDialog", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: UserGardenRecordField.user,
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.user)
        ])
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(UserDialogList), findsNothing);

      // Tap IconButton with Icons.people_alt_rounded (opens listed users dialog)
      await tester.tap(find.byIcon(Icons.people_alt_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(UserDialogList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createListedGardensDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
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
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
          ]
        )
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(GardenDialogList), findsNothing);

      // Tap IconButton with Icons.local_florist (opens listed gardens dialog)
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      expect(find.byType(GardenDialogList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}