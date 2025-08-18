import '../../../test_stubs/users_repository_stubs.dart' as users_repository;

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
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';
import '../../../test_stubs/auth_api_stubs.dart';

void main() {
  group("AppBottomBar", () {
    testWidgets("createCreateAskDialog", (tester) async {
      final user = AppUserFactory(id: "test_user_1");
      final garden = GardenFactory(creator: user);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings;

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      final userGardenRecordReturnValue = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              user: user,
              garden: garden
            ),
            expandFields: [
              UserGardenRecordField.user, UserGardenRecordField.garden
            ]),
        ]
      );
      getUserGardenRecordStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        userGardenRecordReturnValue: userGardenRecordReturnValue,
        mockUsersRepository: mockUsersRepository,
        gardenCreatorID: user.id,
        gardenCreatorReturnValue: getUserRecordModel(user: user)
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

      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState()
        ..currentUser = user
        ..currentUserSettings = userSettings;

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
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState() // for GoToAdminPageTile
        ..currentUser = user
        ..currentUserSettings = userSettings;

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
      final user = AppUserFactory();
      final garden = GardenFactory(creator: user);

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user;

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
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      // TestGesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(() async { return gesture.removePointer(); });

      final appState = AppState() // for GoToAdminPageTile
        ..currentUser = user
        ..currentUserSettings = userSettings;

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
      final user = AppUserFactory();
      final garden = GardenFactory(creator: user);

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
        (_) => garden
      );
      // AppState.currentUser()
      when(
        () => mockAppState.currentUser
      ).thenAnswer(
        (_) => user
      );

      // getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.owner,
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
          ),
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.administrator,
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
          ),
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.member,
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.member,
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
        ]
      );
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: garden.id,
        returnValue: currentGardenUserGardenRecordsItems
      );

      // UsersRepository.getFirstListItem()
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden.creator.id,
        returnValue: getUserRecordModel(user: garden.creator)
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