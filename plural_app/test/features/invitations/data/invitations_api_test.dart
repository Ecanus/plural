import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("invitations_api", () {
    test("createInvitation", () async {
      final tc = TestContext();

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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getUserRecordModel()])
      );

      // InvitationsRepository.create (Open Invitation)
      final Map<String, dynamic> map = {
        InvitationField.creator: tc.user.id,
        InvitationField.expiryDate: DateTime(2010, 10, 20),
        InvitationField.garden: tc.garden.id,
        InvitationField.type: InvitationType.open.name,
        InvitationField.invitee: null,
        InvitationField.uuid: "uuuu-iiii-dd-iid-d",
      };
      when(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).thenAnswer(
        (_) async => (tc.getOpenInvitationRecordModel(), {})
      );

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
        )
      );

      // Test InvitationType.private
      map[InvitationField.type] = InvitationType.private.name;
      map[InvitationField.uuid] = null;
      map[InvitationField.invitee] = tc.otherUser.username;

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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
      final tc = TestContext();

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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      // InvitationsRepository.create (Private Invitation)
      final Map<String, dynamic> map = {
        InvitationField.creator: tc.user.id,
        InvitationField.expiryDate: DateTime(2010, 10, 20),
        InvitationField.garden: tc.garden.id,
        InvitationField.type: InvitationType.private.name,
        InvitationField.invitee: tc.otherUser.username, // note pass username, but create with id
        InvitationField.uuid: null,
      };
      when(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).thenAnswer(
        (_) async => (tc.getPrivateInvitationRecordModel(), {})
      );

      // Check no function calls yet
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockUsersRepository.getList(
          filter: ""
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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
      final tc = TestContext();

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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      // InvitationsRepository.create (Private Invitation)
      final Map<String, dynamic> map = {
        InvitationField.creator: tc.user.id,
        InvitationField.expiryDate: DateTime(2010, 10, 20),
        InvitationField.garden: tc.garden.id,
        InvitationField.type: InvitationType.private.name,
        InvitationField.invitee: tc.otherUser.username, // note pass username, but create with id
        InvitationField.uuid: null,
      };
      when(
        () => mockInvitationsRepository.create(
          body: map
        )
      ).thenAnswer(
        (_) async => (tc.getPrivateInvitationRecordModel(), {})
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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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
          "${UserField.username} = '${tc.otherUser.username}' && "
          "$userGardenRecordsBackRelation != '${tc.garden.id}' && "
          "$invitationsBackRelation != '${tc.otherUser.username}'"
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

    test("getInvitationTypeFromString", () {
      expect(getInvitationTypeFromString("open"), InvitationType.open);
      expect(getInvitationTypeFromString("private"), InvitationType.private);

      expect(getInvitationTypeFromString("invalidValue"), null);
    });
  });
}