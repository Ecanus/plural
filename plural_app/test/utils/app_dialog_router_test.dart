import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
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

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final appState =
              AppState()
              ..currentUser = tc.user;

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      when(
        () => mockAsksRepository.getAsksByUserID(
          filterString: any(named: "filterString"),
          sortString: any(named: "sortString"),
          userID: any(named: "userID")
        )
      ).thenAnswer(
        (_) async => []
      );

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToAskDialogListView();
      expect(appDialogRouter.viewNotifier.value, isA<AskDialogList>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToUserDialogListView", () async {
      final tc = TestContext();
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();

      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);

      when(
        () => mockAuthRepository.getCurrentGardenUsers()
      ).thenAnswer(
        (_) async => [tc.user]
      );

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToUserDialogListView();
      expect(appDialogRouter.viewNotifier.value, isA<UserDialogList>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToUserSettingsDialogView", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      getIt.registerLazySingleton<AppState>(() => appState);

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToUserSettingsDialogView();
      expect(appDialogRouter.viewNotifier.value, isA<UserSettingsList>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToGardenDialogListView", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final appState =
              AppState()
              ..currentUser = tc.user;

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);

      when(
        () => mockGardensRepository.getGardensByUser(tc.user.id)
      ).thenAnswer(
        (_) async => [tc.garden]
      );

      final appDialogRouter = AppDialogRouter();

      expect(appDialogRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogRouter.routeToGardenDialogListView();
      expect(appDialogRouter.viewNotifier.value, isA<GardenDialogList>());
    });

    tearDown(() => GetIt.instance.reset());
  });
}