import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';
import '../../../test_stubs/auth_api_stubs.dart';

void main() {
  group("ListedAsksView", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory(id: "test_user_1");
      final garden = GardenFactory(creator: user);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings; // for initialValue of AppCurrencyPickerFormField

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // getUserGardenRecord() via getUserGardenRecord() (when routing to CreateAskView)
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
            body: AppDialog(
              view: ListedAsksView(listedAskTiles: [
                ListedAskTile(ask: AskFactory(id: "ask_1", creator: user)),
                ListedAskTile(ask: AskFactory(id: "ask_2", creator: user)),
                ListedAskTile(ask: AskFactory(id: "ask_3", creator: user)),
              ])
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.byType(ListedAsksView), findsOneWidget);
      expect(find.byType(ListedAskTile), findsNWidgets(3));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Check AskDialogCreateForm not yet in view
      expect(find.byType(CreateAskView), findsNothing);

      // Tap last RouteToViewButton to go to CreateAskView
      await tester.ensureVisible(find.byType(RouteToViewButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToViewButton).last);
      await tester.pumpAndSettle();

      // Check CreateAskView has been created
      expect(find.byType(CreateAskView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("empty", (tester) async {
      final user = AppUserFactory(id: "test_user_1");
      final garden = GardenFactory(creator: user);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings; // for initialValue of AppCurrencyPickerFormField

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // getUserGardenRecord() via getUserGardenRecord() (when routing to CreateAskView)
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
            body: AppDialog(
              view: ListedAsksView(listedAskTiles: [])
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.byType(ListedAsksView), findsOneWidget);
      expect(find.byType(EmptyListedAsksViewMessage), findsOneWidget);
      expect(find.byType(ListedAskTile), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Check AskDialogCreateForm not yet in view
      expect(find.byType(CreateAskView), findsNothing);

      // Tap last RouteToViewButton to go to CreateAskView
      await tester.ensureVisible(find.byType(RouteToViewButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToViewButton).last);
      await tester.pumpAndSettle();

      // Check CreateAskView has been created
      expect(find.byType(CreateAskView), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}