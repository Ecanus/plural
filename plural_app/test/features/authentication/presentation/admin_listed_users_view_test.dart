import '../../../test_stubs/users_repository_stubs.dart' as users_repository;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_user_tile.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_users_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Test
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';
import '../../../test_stubs/auth_api_stubs.dart';

void main() {
  group("AdminListedUsersView", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory();

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
            user: user,
          ),
        ),
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        returnValue: userGardenRecordRoleItems
      );

      // user -> auth_api.getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.owner
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
          ),
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.administrator
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
          ),
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.member
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.member
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ]
          ),
        ]
      );
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: garden.id,
        returnValue: currentGardenUserGardenRecordsItems
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
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createAdminListedUsersDialog(context),
                  child: Text("The ElevatedButton"),
                );
              }
            ),
          ),
        )
      );

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminListedUsersView), findsOneWidget);
      expect(find.byType(AdminListedUserTile), findsNWidgets(4));
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("emptyMessage", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory();

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
      final userGardenRecordRoleItems = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.administrator,
              user: user,
            ),
          ),
        ]
      );
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        returnValue: userGardenRecordRoleItems
      );

      // user -> auth_api.getCurrentGardenUserGardenRecords()
      final currentGardenUserGardenRecordsItems = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              role: AppUserGardenRole.owner,
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
            ],
          ),
        ]
      );
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: garden.id,
        returnValue: currentGardenUserGardenRecordsItems
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
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createAdminListedUsersDialog(context),
                  child: Text("The ElevatedButton"),
                );
              }
            ),
          ),
        )
      );

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminListedUsersView), findsOneWidget);
      expect(find.byType(AdminListedUserTile), findsNWidgets(1));
      expect(find.text(AdminListedUsersViewText.noAdministrators), findsOneWidget);
      expect(find.text(AdminListedUsersViewText.noMembers), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}