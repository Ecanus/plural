import 'package:flutter_test/flutter_test.dart' as ft;
import '../../../test_stubs/users_repository_stubs.dart' as users_repository;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("invitations_api", () {
    test("acceptInvitationAndCreateUserGardenRecord", () async {
      final list = [1, 2, 3];
      void testFunc() => list.clear();

      final user = AppUserFactory();
      final garden = GardenFactory();

      final openInvitation = InvitationFactory(
        garden: garden,
        type: InvitationType.open
      );

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // InvitationsRepository.delete
      when(
        () => mockInvitationsRepository.delete(id: openInvitation.id)
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.create
      when(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: GetIt.instance<AppState>().currentUserID!,
          }
        )
      ).thenAnswer(
        (_) async => (getUserGardenRecordRecordModel(
          userGardenRecord: AppUserGardenRecordFactory(
            garden: garden,
            role: AppUserGardenRole.member,
            user: user,
          )
        ), {})
      );

      // Check list still has contents (i.e. callback not called)
      expect(list.isEmpty, false);

      // Check methods not called
      verifyNever(
        () => mockInvitationsRepository.delete(id: openInvitation.id)
      );
      verifyNever(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: GetIt.instance<AppState>().currentUserID!,
          }
        )
      );

      await acceptInvitationAndCreateUserGardenRecord(
        openInvitation,
        callback: testFunc
      );

      // Check list no longer has contents (i.e. callback called)
      expect(list.isEmpty, true);

      // Check methods called
      verify(
        () => mockInvitationsRepository.delete(id: openInvitation.id)
      ).called(1);
      verify(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: GetIt.instance<AppState>().currentUserID!,
          }
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("createInvitation", () async {
      final invitationCreator = AppUserFactory();
      final user = AppUserFactory();
      final garden = GardenFactory();

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockBuildContext = MockBuildContext();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).thenAnswer(
        (_) async => {}
      );

      // UsersRepository.getList
      final formattedDate = DateFormat(Formats.dateYMMdd).format(DateTime.now());
      final userGardenRecordsBackRelation = ""
        "${Collection.userGardenRecords}_via_${UserGardenRecordField.user}"
        ".${UserGardenRecordField.garden}";
      final invitationsInviteeBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.invitee}"
        ".${UserField.username}";
      final invitationsExpiryDateBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.expiryDate}";
      when(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getUserRecordModel(user: user)
        ])
      );

      // InvitationsRepository.create (Open Invitation)
      final Map<String, dynamic> map = {
        InvitationField.creator: invitationCreator.id,
        InvitationField.expiryDate: DateTime(2010, 10, 20),
        InvitationField.garden: garden.id,
        InvitationField.type: InvitationType.open.name,
        InvitationField.invitee: null,
        InvitationField.uuid: "uuuu-iiii-dd-iid-d",
      };
      when(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).thenAnswer(
        (_) async => (
          getOpenInvitationRecordModel(
            invitation: InvitationFactory(
              creator: invitationCreator,
              expiryDate: DateTime(2010, 10, 20),
              garden: garden,
              type: InvitationType.open,
              uuid: "uuuu-iiii-dd-iid-d",
            )
          ),
          {}
        )
      );

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      );
      verifyNever(
        () => mockInvitationsRepository.create(
          body: map
        )
      );

      // Call function
      await createInvitation(mockBuildContext, map);

      // Check functions called
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      ).called(1);
      verify(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).called(1);

      // This method still not called because Invitation is open
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      );

      // Test InvitationType.private
      map[InvitationField.type] = InvitationType.private.name;
      map[InvitationField.uuid] = null;
      map[InvitationField.invitee] = user.username;

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      );
      verifyNever(
        () => mockInvitationsRepository.create(
          body: map
        )
      );

      // Call function
      await createInvitation(mockBuildContext, map);

      // Check functions called
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      ).called(1);
      verify(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      ).called(1);
      verify(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("createInvitation noUser", () async {
      final invitationCreator = AppUserFactory();
      final user = AppUserFactory();
      final garden = GardenFactory();

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockBuildContext = MockBuildContext();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).thenAnswer(
        (_) async => {}
      );

      // UsersRepository.getList
      final formattedDate = DateFormat(Formats.dateYMMdd).format(DateTime.now());
      final userGardenRecordsBackRelation = ""
        "${Collection.userGardenRecords}_via_${UserGardenRecordField.user}"
        ".${UserGardenRecordField.garden}";
      final invitationsInviteeBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.invitee}"
        ".${UserField.username}";
      final invitationsExpiryDateBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.expiryDate}";
      when(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      // InvitationsRepository.create (Private Invitation)
      final Map<String, dynamic> map = {
        InvitationField.creator: invitationCreator.id,
        InvitationField.expiryDate: DateTime(2010, 10, 20),
        InvitationField.garden: garden.id,
        InvitationField.invitee: user.username, // Note: pass username, but create() will be with id
        InvitationField.type: InvitationType.private.name,
        InvitationField.uuid: null,
      };
      when(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).thenAnswer(
        (_) async => (getPrivateInvitationRecordModel(
          invitation: InvitationFactory(
            creator: invitationCreator,
            expiryDate: DateTime(2010, 10, 20),
            garden: garden,
            invitee: user,
            type: InvitationType.private,
          )
        ), {})
      );

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      );
      verifyNever(
        () => mockInvitationsRepository.create(
          body: map
        )
      );

      // Call function
      final (record, errorsMap) = await createInvitation(mockBuildContext, map);

      // Check an error was placed in errorsMap
      expect(record, null);
      expect(
        errorsMap,
        {
          InvitationField.invitee: AdminInvitationViewText.createInvitationError
        }
      );

      // Check functions called
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      ).called(1);
      verify(
        () => mockUsersRepository.getList(
          filter: ""
            "${UserField.username} = '${user.username}' && "
            "$userGardenRecordsBackRelation != '${garden.id}' && "
            "($invitationsInviteeBackRelation != '${user.username}' || "
            "$invitationsExpiryDateBackRelation < '$formattedDate')"
        )
      ).called(1);

      // This method still not called because no valid user was found
      verifyNever(
        () => mockInvitationsRepository.create(
          body: map
        )
      );
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("createInvitation PermissionException", (tester) async {
      final invitationCreator = AppUserFactory();
      final user = AppUserFactory();
      final garden = GardenFactory();

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).thenThrow(
        PermissionException()
      );

      // UsersRepository.getList
      final userGardenRecordsBackRelation = ""
        "${Collection.userGardenRecords}_via_${UserGardenRecordField.user}"
        ".${UserGardenRecordField.garden}";

      final invitationsBackRelation = ""
        "${Collection.invitations}_via_${InvitationField.invitee}"
        ".${InvitationField.invitee}"
        ".${UserField.username}";
      when(
        () => mockUsersRepository.getList(
          filter: ""
          "${UserField.username} = '${user.username}' && "
          "$userGardenRecordsBackRelation != '${garden.id}' && "
          "$invitationsBackRelation != '${user.username}'"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      // InvitationsRepository.create (Private Invitation)
      final Map<String, dynamic> map = {
        InvitationField.creator: invitationCreator.id,
        InvitationField.expiryDate: DateTime(2010, 10, 20),
        InvitationField.garden: garden.id,
        InvitationField.invitee: user.username, // Note: pass username, but create() will be with id
        InvitationField.type: InvitationType.private.name,
        InvitationField.uuid: null,
      };
      when(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).thenAnswer(
        (_) async => (getPrivateInvitationRecordModel(
          invitation: InvitationFactory(
            creator: invitationCreator,
            expiryDate: DateTime(2010, 10, 20),
            garden: garden,
            invitee: user,
            type: InvitationType.private,
          )
        ), {})
      );

      final testRouter = GoRouter(
        initialLocation: "/test",
        routes: [
          GoRoute(
            path: "/test",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => createInvitation(context, map),
                    child: Text("The ElevatedButton")
                  );
                }
              )
            )
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, state) => UnauthorizedPage(
            previousRoute: state.uri.queryParameters[QueryParameters.previousRoute],
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
          "${UserField.username} = '${user.username}' && "
          "$userGardenRecordsBackRelation != '${garden.id}' && "
          "$invitationsBackRelation != '${user.username}'"
        )
      );
      verifyNever(
        () => mockInvitationsRepository.create(
          body: map
        )
      );

      // Tap button (to call createInvitation)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check functions called
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      ).called(1);
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
          "${UserField.username} = '${user.username}' && "
          "$userGardenRecordsBackRelation != '${garden.id}' && "
          "$invitationsBackRelation != '${user.username}'"
        )
      );
      verifyNever(
        () => mockInvitationsRepository.create(
          body: map
        )
      );

      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("deleteInvitation", (tester) async {
      final list = [1, 2, 3];
      void testFunc() => list.clear();

      final openInvitation = InvitationFactory(type: InvitationType.open);

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();

      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);

      // InvitationsRepository.delete()
      when(
        () => mockInvitationsRepository.delete(
          id: openInvitation.id,
        )
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => deleteInvitation(
                    openInvitation.id,
                    callback: testFunc
                  ),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      expect(list.isEmpty, false);
      verifyNever(
        () => mockInvitationsRepository.delete(
          id: openInvitation.id,
        )
      );

      // Tap ElevatedButton (to call expireInvitation)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check callback() is called
      expect(list.isEmpty, true);

      verify(
        () => mockInvitationsRepository.delete(
          id: openInvitation.id,
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("getCurrentGardenInvitations", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
        role: AppUserGardenRole.administrator
      );

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
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
          getOpenInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden,
              type: InvitationType.open,
            ),
            expandFields: [InvitationField.creator, InvitationField.invitee]
          ),
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden,
              type: InvitationType.private,
            ),
            expandFields: [InvitationField.creator, InvitationField.invitee]
          ),
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden,
              type: InvitationType.private,
            ),
            expandFields: [InvitationField.creator, InvitationField.invitee]
          ),
        ])
      );

      // Check functions not called yet
      verifyNever(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated"
        )
      );
      verifyNever(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: ""
            "${InvitationField.garden} = '${garden.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: GenericField.created
        )
      );

      final invitationsMap = await getCurrentGardenInvitations(
        mockBuildContext,
        expiryDateThreshold: expiryDateThreshold,
      );

      expect(invitationsMap[InvitationType.open]!.length, 1);
      expect(invitationsMap[InvitationType.private]!.length, 2);

      // Check functions called
      verify(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: ""
            "${InvitationField.garden} = '${garden.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: GenericField.created
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("getCurrentGardenInvitations PermissionException", (tester) async {
      final garden = GardenFactory();

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.viewActiveInvitations])
      ).thenThrow(
        PermissionException()
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
          getOpenInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden,
              type: InvitationType.open,
            ),
            expandFields: [InvitationField.creator, InvitationField.invitee]
          ),
        ])
      );

      final testRouter = GoRouter(
        initialLocation: "/test",
        routes: [
          GoRoute(
            path: "/test",
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => getCurrentGardenInvitations(context),
                    child: Text("The ElevatedButton")
                  );
                }
              )
            )
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, state) => UnauthorizedPage(
            previousRoute: state.uri.queryParameters[QueryParameters.previousRoute],
          )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check functions not called yet
      verifyNever(
        () => mockAppState.verify([AppUserGardenPermission.viewActiveInvitations])
      );
      verifyNever(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: ""
            "${InvitationField.garden} = '${garden.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: GenericField.created
        )
      );

      // Tap button (to call getCurrentGardenInvitations)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check only verify is called
      verify(
        () => mockAppState.verify([AppUserGardenPermission.viewActiveInvitations])
      ).called(1);

      // Check other methods not called
      verifyNever(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: ""
            "${InvitationField.garden} = '${garden.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: GenericField.created
        )
      );

      // Check UnauthorizedPage now shows
      expect(ft.find.byType(UnauthorizedPage), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    test("getInvitationTypeFromString", () {
      expect(getInvitationTypeFromString("open"), InvitationType.open);
      expect(getInvitationTypeFromString("private"), InvitationType.private);

      expect(getInvitationTypeFromString("invalidValue"), null);
    });

    test("getInvitationsByInvitee", () async {
      final user = AppUserFactory();
      final garden1 = GardenFactory();
      final garden2 = GardenFactory();

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockInvitationsRepository.getList
      when(
        () => mockInvitationsRepository.getList(
          expand: ""
            "${InvitationField.creator}, ${InvitationField.invitee}, ${InvitationField.garden}",
          filter: ""
            "${InvitationField.invitee} = '${user.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: "${GenericField.created}, ${InvitationField.expiryDate}",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden1,
              invitee: user,
              type: InvitationType.private,
            ),
            expandFields: [
              InvitationField.creator, InvitationField.invitee, InvitationField.garden
            ]
          ),
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden2,
              invitee: user,
              type: InvitationType.private,
            ),
            expandFields: [
              InvitationField.creator, InvitationField.invitee, InvitationField.garden
            ]
          ),
        ])
      );

      // UsersRepository.getFirstListItem()
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden1.creator.id,
        returnValue: getUserRecordModel(user: garden1.creator)
      );
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden2.creator.id,
        returnValue: getUserRecordModel(user: garden2.creator)
      );

      final invitationsList = await getInvitationsByInvitee(
        user.id,
        expiryDateThreshold: expiryDateThreshold,
      );

      expect(invitationsList.length, 2);
    });

    tearDown(() => GetIt.instance.reset());

    test("validateInvitationUUIDAndCreateUserGardenRecord", () async {
      final list = [""];
      void testSuccess(String value) => list[0] = value;
      void testError(String value) => list[0] = value;

      final user = AppUserFactory();

      final openInvitation = InvitationFactory(
        type: InvitationType.open
      );

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // mockInvitationsRepository.getList
      when(
        () => mockInvitationsRepository.getList(
          expand: InvitationField.garden,
          filter: ""
            "${InvitationField.uuid} = '${openInvitation.uuid}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getOpenInvitationRecordModel(
            invitation: openInvitation,
            expandFields: [
              InvitationField.creator, InvitationField.garden
            ]
          ),
        ])
      );

      // UserGardenRecordsRepository.create
      when(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: user.id,
          }
        )
      ).thenAnswer(
        (_) async => (getUserGardenRecordRecordModel(
          userGardenRecord: AppUserGardenRecordFactory(
            garden: openInvitation.garden,
            role: AppUserGardenRole.member,
            user: user,
          )
        ), {})
      );

      // Check no methods called and list has "" as first
      expect(list.first, "");
      verifyNever(
        () => mockInvitationsRepository.getList(
          expand: InvitationField.garden,
          filter: ""
            "${InvitationField.uuid} = '${openInvitation.uuid}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
        )
      );
      verifyNever(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: user.id,
          }
        )
      );

      await validateInvitationUUIDAndCreateUserGardenRecord(
        openInvitation.uuid!,
        successCallback: testSuccess,
        errorCallback: testError,
      );

      // Check methods called and list now has tc.garden.name as first
      expect(list.first, openInvitation.garden.name);
      verify(
        () => mockInvitationsRepository.getList(
          expand: InvitationField.garden,
          filter: ""
            "${InvitationField.uuid} = '${openInvitation.uuid}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
        )
      ).called(1);
      verify(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: user.id,
          }
        )
      ).called(1);

      // UserGardenRecordsRepository.create. Returns non-empty errorsMap
      when(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.doDocumentReadDate: DateFormat(Formats.dateYMMdd).format(
              AppUserGardenRecord.initialDoDocumentReadDate),
            UserGardenRecordField.garden: openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: user.id,
          }
        )
      ).thenAnswer(
        (_) async => (
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: openInvitation.garden,
              role: AppUserGardenRole.member,
              user: user,
            )
          ), {"error": "error"}
        )
      );

      await validateInvitationUUIDAndCreateUserGardenRecord(
        openInvitation.uuid!,
        successCallback: testSuccess,
        errorCallback: testError,
      );

      // Check list now has error message as first
      // (because a non-empty errorsMap was returned during create)
      expect(list.first, InvitationsText.createUserGardenRecordError);

    });

     tearDown(() => GetIt.instance.reset());
  });
}