import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
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
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("AdminListedUsersView", () {
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

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel([
              UserGardenRecordField.user, UserGardenRecordField.garden
            ], role: AppUserGardenRole.owner),
            tc.getExpandUserGardenRecordRecordModel([
              UserGardenRecordField.user, UserGardenRecordField.garden
            ], role: AppUserGardenRole.administrator),
            tc.getExpandUserGardenRecordRecordModel([
              UserGardenRecordField.user, UserGardenRecordField.garden
            ]),
            tc.getExpandUserGardenRecordRecordModel([
              UserGardenRecordField.user, UserGardenRecordField.garden
            ]),
          ]
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
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

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "${UserGardenRecordField.user}.${UserField.username}"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel([
              UserGardenRecordField.user, UserGardenRecordField.garden
            ], role: AppUserGardenRole.owner),
          ]
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
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