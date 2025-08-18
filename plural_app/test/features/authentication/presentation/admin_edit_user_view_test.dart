import '../../../test_stubs/users_repository_stubs.dart' as users_repository;

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
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_edit_user_view.dart';
import 'package:plural_app/src/features/authentication/presentation/expel_user_button.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Test
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';
import '../../../test_stubs/auth_api_stubs.dart';

void main() {
  group("AdminEditUserView", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        user: user,
      );

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // user, getUserGardenRecordRole() via verify()
      final userGardenRecordRoleItems = ResultList<RecordModel>(items: [
        getUserGardenRecordRecordModel(
          userGardenRecord: AppUserGardenRecordFactory(
            garden: garden,
            role: AppUserGardenRole.administrator,
            user: user
          ),
        )
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        returnValue: userGardenRecordRoleItems
      );

      // user -> auth_api.getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(items: [
        getUserGardenRecordRecordModel(
          userGardenRecord: AppUserGardenRecordFactory(
            garden: garden,
            role: AppUserGardenRole.owner,
            user: user,
          ),
          expandFields: [
            UserGardenRecordField.user,
            UserGardenRecordField.garden
          ],
        )
      ]);
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: garden.id,
        returnValue: currentGardenUserGardenRecordsItems,
      );

      // user -> UsersRepository.getFirstListItem()
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden.creator.id,
        returnValue: getUserRecordModel(user: garden.creator)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AdminEditUserView(userGardenRecord: userGardenRecord)
            ),
          ),
        )
      );

      // Check no ExpelUserButton (because isCurrentUser)
      expect(find.byType(ExpelUserButton), findsNothing);

      verifyNever(
        () => mockUserGardenRecordsRepository.getList(
          expand: UserGardenRecordField.user,
          filter: "${UserGardenRecordField.garden} = '${garden.id}'",
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
          expand: UserGardenRecordField.user,
          filter: "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("ExpelUserButton", (tester) async {
      final currentUser = AppUserFactory();

      final otherUser = AppUserFactory();
      final otherUserGardenRecord = AppUserGardenRecordFactory(
        user: otherUser,
      );

      final appState = AppState.skipSubscribe()
        ..currentUser = currentUser;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AdminEditUserView(userGardenRecord: otherUserGardenRecord)
            ),
          ),
        )
      );

      // Check ExpelUserButton shows (because userGardenRecord belongs to non-currentUser)
      expect(find.byType(ExpelUserButton), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}