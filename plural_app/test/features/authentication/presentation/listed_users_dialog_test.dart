import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_user_tile.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("UserDialogList test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      // GetIt
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);

      // AuthRepository.getCurrentGardenUsers()
      when(
        () => mockAuthRepository.getCurrentGardenUsers()
      ).thenAnswer(
        (_) async => [tc.user, tc.user, tc.user, tc.user]
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createListedUsersDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check AskDialogList not yet displayed
      expect(find.byType(UserDialogList), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(UserDialogList), findsOneWidget);
      expect(find.byType(ListedUsersHeader), findsOneWidget);
      expect(find.byType(ListedUserTile), findsNWidgets(4));
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}