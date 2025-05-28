import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/delete_account_button.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../test_mocks.dart';
import '../test_widgets.dart';

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
      final mockAsksRepository = MockAsksRepository();
      final mockAuthRepository = MockAuthRepository();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);

      // AsksRepository.deleteCurrentUserAsks()
      when(
        () => mockAsksRepository.deleteCurrentUserAsks()
      ).thenAnswer(
        (_) async => () {}
      );
      // AuthRepository.deleteCurrentUserGardenRecords()
      when(
        () => mockAuthRepository.deleteCurrentUserGardenRecords()
      ).thenAnswer(
        (_) async => () {}
      );
      // AuthRepository.deleteCurrentUserSettings()
      when(
        () => mockAuthRepository.deleteCurrentUserSettings()
      ).thenAnswer(
        (_) async => () {}
      );
      // AuthRepository.deleteCurrentUser()
      when(
        () => mockAuthRepository.deleteCurrentUser()
      ).thenAnswer(
        (_) async => () {}
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