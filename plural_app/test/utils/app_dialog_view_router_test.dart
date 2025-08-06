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

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_create_invitation_view.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitations_view.dart';

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

      // getUserGardenRecordRole() through AppState.verify()
      final items1 = ResultList<RecordModel>(
        items: [
          tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator),
        ]
      );
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: items1
      );

      // getCurrentGardenUserGardenRecords() through AppState.verify()
      final items = ResultList<RecordModel>(
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
      );
      getCurrentGardenUserGardenRecordsStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        gardenID: tc.garden.id,
        returnValue: items,
      );

      // UsersRepository.getFirstListItem()
      usersRepositoryGetFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: tc.user.id,
        returnValue: tc.getUserRecordModel(),
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

    test("routeToAdminCreateInvitationView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToAdminCreateInvitationView();
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminCreateInvitationView>());
    });

    test("routeToAdminListedInvitationsView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      final tc = TestContext();

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMddHHms).format(expiryDateThreshold);

      final appState = AppState.skipSubscribe()
        ..currentGarden = tc.garden
        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // getUserGardenRecordRole() through AppState.verify()
      final items = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: items
      );

      // InvitationsRepository.getList()
      when(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: ""
            "${InvitationField.garden} = '${tc.garden.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: GenericField.created
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getPrivateInvitationRecordModel(
            expand: [InvitationField.creator, InvitationField.invitee]
          ),
        ])
      );

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToAdminListedInvitationsView(mockBuildContext);
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminListedInvitationsView>());
    });

    tearDown(() => GetIt.instance.reset());
  });
}