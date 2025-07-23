import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/edit_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/examine_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_view.dart';
import 'package:plural_app/src/features/asks/presentation/sponsored_asks_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_edit_user_view.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_users_view.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_view.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/admin_current_garden_settings_view.dart';
import 'package:plural_app/src/features/gardens/presentation/admin_options_view.dart';
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../test_context.dart';
import '../test_mocks.dart';
import '../test_stubs.dart';

void main() {
  group("AppDialogViewRouter", () {
    test("setRouteTo", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.setRouteTo(Container());
      expect(appDialogViewRouter.viewNotifier.value, isA<Container>());
    });

    test("routeToCreateAskView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToCreateAskView();
      expect(appDialogViewRouter.viewNotifier.value, isA<CreateAskView>());
    });

    test("routeToEditAskView", () async {
      final tc = TestContext();
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToEditAskView(tc.ask);
      expect(appDialogViewRouter.viewNotifier.value, isA<EditAskView>());
    });

    test("routeToExamineAskView", () async {
      final tc = TestContext();
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToExamineAskView(tc.ask);
      expect(appDialogViewRouter.viewNotifier.value, isA<ExamineAskView>());
    });

    test("routeToListedAsksView", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden // for getAsksByUserID
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // Stubs
      getAsksByUserIDStub(
        mockAsksRepository: mockAsksRepository,
        asksSort: GenericField.created,
        gardenID: tc.garden.id,
        asksReturnValue: ResultList<RecordModel>(items: [tc.getAskRecordModel()]),
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        usersReturnValue: tc.getUserRecordModel(),
      );

      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToListedAsksView();
      expect(appDialogViewRouter.viewNotifier.value, isA<ListedAsksView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToSponsoredAsksView", () async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden // for getAsksByUserID
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      final datetimeNow = DateTime.parse(
        DateFormat(Formats.dateYMMddHHms).format(DateTime.now())).toLocal();
      final nowString = DateFormat(Formats.dateYMMddHHms).format(datetimeNow);

      final asksFilter = ""
        "${AskField.garden} = '${tc.garden.id}' " // mind the trailing space
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} > '$nowString'"
        "&& ${AskField.creator} != '${tc.user.id}'"
        "&& ${AskField.sponsors} ~ '${tc.user.id}'";

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksFilter: asksFilter,
        asksReturnValue: ResultList<RecordModel>(items: [tc.getAskRecordModel()]),
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        usersReturnValue: tc.getUserRecordModel(),
      );

      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToSponsoredAsksView();
      expect(appDialogViewRouter.viewNotifier.value, isA<SponsoredAsksView>());
    });

    test("routeToAdminEditUserView", () async {
      final tc = TestContext();
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToAdminEditUserView(tc.userGardenRecord);
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminEditUserView>());
    });

    test("routeToAdminListedUsersView", () async {
      final tc = TestContext();
      final appDialogViewRouter = AppDialogViewRouter();

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList(), getUserGardenRecordRole()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
          "${UserGardenRecordField.user} = '${tc.user.id}' && "
          "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator),
          ]
        )
      );

      // UserGardenRecordsRepository.getList(), getCurrentGardenUserGardenRecords()
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

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToAdminListedUsersView(mockBuildContext);
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminListedUsersView>());
    });

    test("routeToUserSettingsView", () async {
      final tc = TestContext();

      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToUserSettingsView();
      expect(appDialogViewRouter.viewNotifier.value, isA<UserSettingsView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToAdminCurrentGardenSettingsView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToAdminCurrentGardenSettingsView();
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminCurrentGardenSettingsView>());
    });

    test("routeToAdminOptionsView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToAdminOptionsView();
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminOptionsView>());
    });

    test("routeToCurrentGardenSettingsView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToCurrentGardenSettingsView();
      expect(appDialogViewRouter.viewNotifier.value, isA<CurrentGardenSettingsView>());
    });
  });
}