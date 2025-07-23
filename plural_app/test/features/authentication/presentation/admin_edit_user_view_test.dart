import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_edit_user_view.dart';
import 'package:plural_app/src/features/authentication/presentation/expel_user_button.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Test
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("AdminEditUserView", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // user -> auth_api.getUserGardenRecordRole()
      final userGardenRecordRoleItems = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: userGardenRecordRoleItems
      );

      // user -> auth_api.getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(items: [
        tc.getExpandUserGardenRecordRecordModel(
          [UserGardenRecordField.user, UserGardenRecordField.garden],
          role: AppUserGardenRole.owner,
        )
      ]);
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: tc.garden.id,
        returnValue: currentGardenUserGardenRecordsItems,
      );

      // user -> UsersRepository.getFirstListItem()
      usersRepositoryGetFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        returnValue: tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AdminEditUserView(userGardenRecord: tc.userGardenRecord)
            ),
          ),
        )
      );

      // Check no ExpelUserButton (because isCurrentUser)
      expect(find.byType(ExpelUserButton), findsNothing);

      verifyNever(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      );

      // Tap the RouteToListedUsersViewButton to check the method stub is called
      await tester.ensureVisible(find.byType(RouteToListedUsersViewButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToListedUsersViewButton));
      await tester.pumpAndSettle();

      verify(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("ExpelUserButton", (tester) async {
      final tc = TestContext();

      final otherUser = AppUser(
        firstName: "firstName",
        id: "id",
        lastName: "lastName",
        username: "username"
      );

      final appState = AppState.skipSubscribe()
                        ..currentUser = otherUser;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AdminEditUserView(userGardenRecord: tc.userGardenRecord)
            ),
          ),
        )
      );

      // Check no ExpelUserButton (because isCurrentUser)
      expect(find.byType(ExpelUserButton), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}