import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_user_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';

void main() {
  group("AdminListedUserTile", () {
    testWidgets("isCurrentUser", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        user: user
      );

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedUserTile(userGardenRecord: userGardenRecord)
              ],
            ),
          ),
        )
      );

      // Check Icon.person is shown becaause userGardenRecord belongs to currentUser
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Create userGardenRecord with user != isCurrentUser. Role is member
      final newUser = AppUserFactory();
      final newUserGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        id: "newUserGardenRecord",
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

      // Check Icon.person is not shown because newUserGardenRecord does not belong to currentUser
      expect(find.byIcon(Icons.person), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("isEditable", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        user: user
      );

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final mockAppDialogViewRouter = MockAppDialogViewRouter();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);

      // Create a User that is the owner (so that the tile not isEditable)
      final newUser = AppUserFactory();
      final newUserGardenRecord = AppUserGardenRecord(
        garden: garden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        id: "newUserGardenRecord",
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

      // Now, try with user with role of member instead (so that the tile is editable)
      when(
        () => mockAppDialogViewRouter.routeToAdminEditUserView(userGardenRecord)
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedUserTile(userGardenRecord: userGardenRecord)
              ],
            ),
          ),
        )
      );

      // Check Icon.arrow_forward_ios is shown if isEditable
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminEditUserView(userGardenRecord)
      );

      // Tap on the ListTile (to test on the method)
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      verify(
        () => mockAppDialogViewRouter.routeToAdminEditUserView(userGardenRecord)
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());
  });
}