import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../test_context.dart';
import '../test_mocks.dart';

void main() {
  group("App dialog router test", () {
    test("setRouteTo", () async {
      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.setRouteTo(Container());
      expect(appDialogRouter.viewNotifier.value, isA<Container>());
    });

    test("routeToCreatableAskDialogView", () async {
      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.routeToCreatableAskDialogView();
      expect(appDialogRouter.viewNotifier.value, isA<AskDialogCreateForm>());
    });

    test("routeToEditableAskDialogView", () async {
      final tc = TestContext();
      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.routeToEditableAskDialogView(tc.ask);
      expect(appDialogRouter.viewNotifier.value, isA<AskDialogEditForm>());
    });

    test("routeToAskDialogListView", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden // for getAsksByUserID
                        ..currentUser = tc.user;

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

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToAskDialogListView();
      expect(appDialogRouter.viewNotifier.value, isA<AskDialogList>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToUserDialogListView", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden // for getCurrentGardenUsers()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.user)
        ])
      );

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToUserDialogListView();
      expect(appDialogRouter.viewNotifier.value, isA<UserDialogList>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToUserSettingsDialogView", () async {
      final tc = TestContext();

      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToUserSettingsDialogView();
      expect(appDialogRouter.viewNotifier.value, isA<UserSettingsList>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToGardenDialogListView", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden // for excludesCurrentGarden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden)
        ])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToGardenDialogListView();
      expect(appDialogRouter.viewNotifier.value, isA<GardenDialogList>());
    });

    tearDown(() => GetIt.instance.reset());
  });
}