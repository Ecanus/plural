import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_users_view.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_view.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/admin_current_garden_settings_view.dart';
import 'package:plural_app/src/features/gardens/presentation/admin_options_view.dart';
import 'package:plural_app/src/features/gardens/presentation/app_bottom_bar.dart';
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("AppBottomBar", () {
    testWidgets("createCreateAskDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

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

      // Check AppBottomBar is rendered; CreateAskView is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(CreateAskView), findsNothing);

      // Tap IconButton with Icons.add (opens create ask dialog)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(CreateAskView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createUserSettingsDialog", (tester) async {
      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

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

      // Check AppBottomBar is rendered; UserSettingsView not rendered
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(UserSettingsView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.settings (opens user settings dialog)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(UserSettingsView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createCurrentGardenDialog", (tester) async {
      final tc = TestContext();

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState() // for GoToAdminPageTile
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);

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

      // Check AppBottomBar is rendered; CurrentGardenSettingsView is not
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(CurrentGardenSettingsView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.local_florist (opens current garden dialog)
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      expect(find.byType(CurrentGardenSettingsView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createAdminCurrentGardenSettingsDialog", (tester) async {
      final tc = TestContext();

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter(isAdminPage: true,);
              }
            ),
          ),
        ));

      // Check AppBottomBar is rendered; AdminCurrentGardenSettingsView is not
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(AdminCurrentGardenSettingsView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.local_florist (opens admin current garden settings
      // dialog)
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      expect(find.byType(AdminCurrentGardenSettingsView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createAdminOptionsDialog", (tester) async {
      final tc = TestContext();

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState() // for GoToAdminPageTile
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter(isAdminPage: true,);
              }
            ),
          ),
        ));

      // Check AppBottomBar is rendered; AskDialogList is not
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(AdminOptionsView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.security (opens admin options dialog)
      await tester.tap(find.byIcon(Icons.security));
      await tester.pumpAndSettle();

      expect(find.byType(AdminOptionsView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createAdminListedUsersDialog", (tester) async {
      final tc = TestContext();

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify(any())
      ).thenAnswer(
        (_) async => {}
      );
      // AppState.currentGarden()
      when(
        () => mockAppState.currentGarden
      ).thenAnswer(
        (_) => tc.garden
      );
      // AppState.currentUser()
      when(
        () => mockAppState.currentUser
      ).thenAnswer(
        (_) => tc.user
      );

      // getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(
        items: [
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
            role: AppUserGardenRole.owner
          ),
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
            role: AppUserGardenRole.administrator
          ),
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
          tc.getUserGardenRecordRecordModel(
            expand: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
        ]
      );
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: tc.garden.id,
        returnValue: currentGardenUserGardenRecordsItems
      );

      // UsersRepository.getFirstListItem()
      usersRepositoryGetFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        returnValue: tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter(isAdminPage: true,);
              }
            ),
          ),
        ));

      // Check AppBottomBar is rendered; AdminListedUsersView is not
      final appBottomBar = find.byType(AppBottomBar);
      expect(appBottomBar, findsOneWidget);
      expect(find.byType(AdminListedUsersView), findsNothing);

      // Move gesture to AppBottomBar so that the other two buttons will reveal
      await gesture.moveTo(tester.getCenter(appBottomBar));
      await tester.pumpAndSettle();

      // Tap IconButton with Icons.security (opens admin options dialog)
      await tester.tap(find.byIcon(Icons.people_alt));
      await tester.pumpAndSettle();

      expect(find.byType(AdminListedUsersView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}