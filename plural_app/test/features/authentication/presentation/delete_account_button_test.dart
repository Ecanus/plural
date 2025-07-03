import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Common Widgets
import 'package:plural_app/src/features/authentication/presentation/delete_account_button.dart';
import 'package:plural_app/src/constants/fields.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:pocketbase/pocketbase.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_widgets.dart';

void main() {
  group("DeleteAccountButton test", () {
    testWidgets("cancelConfirmDeleteAccount", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return DeleteAccountButton();
              }
            )
          ),
        )
      );

      // Check ConfirmDeleteAccountDialog not yet displayed
      expect(find.byType(ConfirmDeleteAccountDialog), findsNothing);

      // Tap ConfirmDeleteAccountDialog (to open dialog)
      await tester.tap(find.byType(DeleteAccountButton));
      await tester.pumpAndSettle();

      // Check ConfirmDeleteAccountDialog is displayed
      expect(find.byType(ConfirmDeleteAccountDialog), findsOneWidget);

      // Tap cancel button (to close dialog)
      await tester.tap(find.text(LandingPageText.cancelConfirmDeleteAccount));
      await tester.pumpAndSettle();

      // Check Dialog no longer displayed
      expect(find.byType(ConfirmDeleteAccountDialog), findsNothing);
    });

    testWidgets("submitDeleteAccount", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user // for deleteCurrentUserAsks()
                        ..currentUserSettings = tc.userSettings;

      final mockAsksRepository = MockAsksRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUserSettingsRepository = MockUserSettingsRepository();
      final mockUsersRepository = MockUsersRepository();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => mockUserSettingsRepository);
      getIt.registerLazySingleton<UsersRepository>(
        () => mockUsersRepository);

      // AsksRepository.getList()
      final asksResultList = ResultList<RecordModel>(items: [tc.getAskRecordModel()]);
      when(
        () => mockAsksRepository.getList(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => asksResultList
      );
      // mockAsksRepository.bulkDelete()
      when(
        () => mockAsksRepository.bulkDelete(resultList: asksResultList)
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.getList()
      final userGardenRecordsResultList = ResultList<RecordModel>(
        items: [tc.getUserGardenRecordRecordModel(), tc.getUserGardenRecordRecordModel()]
      );
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => userGardenRecordsResultList
      );
      // UserGardenRecordsRepository.bulkDelete()
      when(
        () => mockUserGardenRecordsRepository.bulkDelete(
          resultList: userGardenRecordsResultList)
      ).thenAnswer(
        (_) async => {}
      );

      // UserSettingsRepository.delete()
      when(
        () => mockUserSettingsRepository.delete(id: tc.userSettings.id)
      ).thenAnswer(
        (_) async => {}
      );

      // UsersRepository.delete()
      when(
        () => mockUsersRepository.delete(id: tc.user.id)
      ).thenAnswer(
        (_) async => {}
      );

      var testRouter = GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => TestDeleteAccountButton()
          ),
          GoRoute(
            path: Routes.signIn,
            builder: (_, __) => BlankPage(
              widget: Text("Successfully routed to signIn")
              )
          )
        ]);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check text not yet rendered (reroute hasn't taken place)
      expect(find.text("Successfully routed to signIn"), findsNothing);

      // Check ConfirmDeleteAccountDialog not yet displayed
      expect(find.byType(ConfirmDeleteAccountDialog), findsNothing);

      // Tap ConfirmDeleteAccountDialog (to open dialog)
      await tester.tap(find.byType(DeleteAccountButton));
      await tester.pumpAndSettle();

      // Check ConfirmDeleteAccountDialog is displayed
      expect(find.byType(ConfirmDeleteAccountDialog), findsOneWidget);

      // Enter the confirmDeleteAccountValue (pumpAndSettle to allow setState())
      await tester.enterText(
        find.byType(TextField), LandingPageText.confirmDeleteAccountValue,
      );
      await tester.pumpAndSettle();

      // Tap on the delete button
      await tester.tap(find.text(LandingPageText.deleteAccount).last);
      await tester.pumpAndSettle();

      // Check text rendered (reroute has taken place)
      expect(find.text("Successfully routed to signIn"), findsOneWidget);
    });

  });
}