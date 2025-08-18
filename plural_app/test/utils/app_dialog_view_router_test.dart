import '../test_stubs/users_repository_stubs.dart' as users_repository;

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
import 'package:plural_app/src/features/gardens/presentation/examine_do_document_view.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_create_invitation_view.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitations_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../test_factories.dart';
import '../test_mocks.dart';
import '../test_record_models.dart';
import '../test_stubs/asks_api_stubs.dart';
import '../test_stubs/auth_api_stubs.dart';

void main() {
  group("AppDialogViewRouter", () {
    test("setRouteTo", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.setRouteTo(Container());
      expect(appDialogViewRouter.viewNotifier.value, isA<Container>());
    });

    test("routeToCreateAskView", () async {
      final user = AppUserFactory(id: "test_user_1");
      final garden = GardenFactory(creator: user);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings;

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);


      // UserGardenRecordsRepository.getList()
      final userGardenRecordReturnValue = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              user: user,
              garden: garden
            ),
            expandFields: [
              UserGardenRecordField.user, UserGardenRecordField.garden
            ]),
        ]
      );
      getUserGardenRecordStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        userGardenRecordReturnValue: userGardenRecordReturnValue,
        mockUsersRepository: mockUsersRepository,
        gardenCreatorID: user.id,
        gardenCreatorReturnValue: getUserRecordModel(user: user)
      );

      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToCreateAskView();
      expect(appDialogViewRouter.viewNotifier.value, isA<CreateAskView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToEditAskView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToEditAskView(AskFactory());
      expect(appDialogViewRouter.viewNotifier.value, isA<EditAskView>());
    });

    test("routeToExamineAskView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToExamineAskView(AskFactory());
      expect(appDialogViewRouter.viewNotifier.value, isA<ExamineAskView>());
    });

    test("routeToListedAsksView", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden // for getAsksByUserID
        ..currentUser = user;

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
        gardenID: garden.id,
        asksReturnValue: ResultList<RecordModel>(items: [
          getAskRecordModel(ask: AskFactory(creator: user))
        ]),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
      );

      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToListedAsksView();
      expect(appDialogViewRouter.viewNotifier.value, isA<ListedAsksView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToSponsoredAsksView", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden // for getAsksByUserID
        ..currentUser = user;

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
        "${AskField.garden} = '${garden.id}' " // mind the trailing space
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} > '$nowString'"
        "&& ${AskField.creator} != '${user.id}'"
        "&& ${AskField.sponsors} ~ '${user.id}'";

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksFilter: asksFilter,
        asksReturnValue: ResultList<RecordModel>(items: [
          getAskRecordModel(ask: AskFactory(creator: user))
        ]),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
      );

      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToSponsoredAsksView();
      expect(appDialogViewRouter.viewNotifier.value, isA<SponsoredAsksView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToAdminEditUserView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToAdminEditUserView(AppUserGardenRecordFactory());
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminEditUserView>());
    });

    test("routeToAdminListedUsersView", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final appDialogViewRouter = AppDialogViewRouter();

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockBuildContext = MockBuildContext();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // getUserGardenRecordRole() via verify()
      final items1 = ResultList<RecordModel>(
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
        returnValue: items1
      );

      // getCurrentGardenUserGardenRecords() through AppState.verify()
      final items = ResultList<RecordModel>(
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
        returnValue: items,
      );

      // UsersRepository.getFirstListItem()
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden.creator.id,
        returnValue: getUserRecordModel(user: garden.creator),
      );

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToAdminListedUsersView(mockBuildContext);
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminListedUsersView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToUserSettingsView", () async {
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState()
        ..currentUser = user
        ..currentUserSettings = userSettings;

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

    test("routeToExamineDoDocumentView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

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
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: userGardenRecord,
              expandFields: [
                UserGardenRecordField.user, UserGardenRecordField.garden
              ],
            ),
          ]
        )
      );

      // UsersRepository.getFirstListItem()
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden.creator.id,
        returnValue: getUserRecordModel(user: garden.creator)
      );

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      await appDialogViewRouter.routeToExamineDoDocumentView();
      expect(appDialogViewRouter.viewNotifier.value, isA<ExamineDoDocumentView>());
    });

    tearDown(() => GetIt.instance.reset());

    test("routeToAdminCreateInvitationView", () async {
      final appDialogViewRouter = AppDialogViewRouter();

      expect(appDialogViewRouter.viewNotifier.value, isA<SizedBox>());
      appDialogViewRouter.routeToAdminCreateInvitationView();
      expect(appDialogViewRouter.viewNotifier.value, isA<AdminCreateInvitationView>());
    });

    test("routeToAdminListedInvitationsView", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final appDialogViewRouter = AppDialogViewRouter();

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user;

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

      // getUserGardenRecordRole() via verify()
      final items = ResultList<RecordModel>(items: [
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
        returnValue: items
      );

      // InvitationsRepository.getList()
      when(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: ""
            "${InvitationField.garden} = '${garden.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: GenericField.created
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getPrivateInvitationRecordModel(
            expandFields: [InvitationField.creator, InvitationField.invitee]
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