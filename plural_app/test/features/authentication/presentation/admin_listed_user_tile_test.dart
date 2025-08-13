import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_user_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("AdminListedUserTile", () {
    testWidgets("isCurrentUser", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedUserTile(userGardenRecord: tc.userGardenRecord)
              ],
            ),
          ),
        )
      );

      // Check Icon.person is shown is isCurrentUser
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Change userGardenRecord.user (so that !isCurrentUser)
      final newUser = AppUser(
        firstName: "firstName",
        id: "id",
        lastName: "lastName",
        username: "username"
      );
      final newUserGardenRecord = AppUserGardenRecord(
        garden: tc.garden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        id: "garden",
        role: AppUserGardenRole.member,
        user: newUser
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedUserTile(userGardenRecord: newUserGardenRecord)
              ],
            ),
          ),
        )
      );

      // Check Icon.person is shown is isCurrentUser
      expect(find.byIcon(Icons.person), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("isEditable", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentUser = tc.user;

      final mockAppDialogViewRouter = MockAppDialogViewRouter();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);

      // Use a User who is the owner (so that the tile not isEditable)
      final newUser = AppUser(
        firstName: "firstName",
        id: "id",
        lastName: "lastName",
        username: "username"
      );
      final newUserGardenRecord = AppUserGardenRecord(
        garden: tc.garden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        id: "garden",
        role: AppUserGardenRole.owner,
        user: newUser
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedUserTile(userGardenRecord: newUserGardenRecord)
              ],
            ),
          ),
        )
      );

      // Check Icon.arrow_forward_ios is not shown if not isEditable
      expect(find.byIcon(Icons.arrow_forward_ios), findsNothing);

      // Now, use a user who is a member (so that the tile is editable)
      when(
        () => mockAppDialogViewRouter.routeToAdminEditUserView(tc.userGardenRecord)
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedUserTile(userGardenRecord: tc.userGardenRecord)
              ],
            ),
          ),
        )
      );

      // Check Icon.arrow_forward_ios is shown if isEditable
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminEditUserView(tc.userGardenRecord)
      );

      // Tap on the ListTile (to test on the method)
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      verify(
        () => mockAppDialogViewRouter.routeToAdminEditUserView(tc.userGardenRecord)
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());
  });
}