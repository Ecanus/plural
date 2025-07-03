import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/edit_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_view.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../test_context.dart';
import '../test_mocks.dart';

void main() {
  group("App dialog router test", () {
    test("setRouteTo", () async {
      final appDialogRouter = AppDialogViewRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.setRouteTo(Container());
      expect(appDialogRouter.viewNotifier.value, isA<Container>());
    });

    test("routeToCreateAskView", () async {
      final appDialogRouter = AppDialogViewRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.routeToCreateAskView();
      expect(appDialogRouter.viewNotifier.value, isA<CreateAskView>());
    });

    test("routeToEditAskView", () async {
      final tc = TestContext();
      final appDialogRouter = AppDialogViewRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.routeToEditAskView(tc.ask);
      expect(appDialogRouter.viewNotifier.value, isA<EditAskView>());
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

      final appDialogRouter = AppDialogViewRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToListedAsksView();
      expect(appDialogRouter.viewNotifier.value, isA<ListedAsksView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToUserSettingsDialogView", () async {
      final tc = TestContext();

      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      final appDialogRouter = AppDialogViewRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToUserSettingsView();
      expect(appDialogRouter.viewNotifier.value, isA<UserSettingsView>());
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
          tc.getExpandUserGardenRecordRecordModel([UserGardenRecordField.garden])
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

      final appDialogRouter = AppDialogViewRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      appDialogRouter.routeToCurrentGardenSettingsView();
      expect(appDialogRouter.viewNotifier.value, isA<CurrentGardenSettingsView>());
    });

    tearDown(() => GetIt.instance.reset());
  });
}