import '../../../test_stubs/users_repository_stubs.dart' as users_repository;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';
import 'package:plural_app/src/features/invitations/presentation/landing_page_invitation_tile.dart';
import 'package:plural_app/src/features/invitations/presentation/landing_page_invitations_tab.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';

void main() {
  group("LandingPageInvitationsTab", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory();
      final garden1 = GardenFactory();
      final garden2 = GardenFactory();

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockInvitationsRepository.getList
      when(
        () => mockInvitationsRepository.getList(
          expand: ""
            "${InvitationField.creator}, ${InvitationField.invitee}, ${InvitationField.garden}",
          filter: any(named: "filter"), // use filter because of internal DateTime.now() call
          sort: "${GenericField.created}, ${InvitationField.expiryDate}",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden1,
              invitee: user,
              type: InvitationType.private
            ),
            expandFields: [
              InvitationField.creator, InvitationField.invitee, InvitationField.garden
            ]
          ),
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden2,
              invitee: user,
              type: InvitationType.private
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageInvitationsTab(),
          ),
        )
      );

      // Check CircularProgressIndicator are rendered
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      // Check widgets are rendered
      expect(find.byType(AppDialogCategoryHeader), findsNWidgets(2));
      expect(find.byType(OpenInvitationCodeTextField), findsOneWidget);
      expect(find.byType(PrivateInvitationsListView), findsOneWidget);

      // Check LandingPageInvitationTile's are rendered
      await tester.pumpAndSettle();
      expect(find.byType(LandingPageInvitationTile), findsNWidgets(2));
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("callbacks", (tester) async {
      final user = AppUserFactory();
      final garden1 = GardenFactory();
      final garden2 = GardenFactory();

      final openInvitation = InvitationFactory(type: InvitationType.open);

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // mockInvitationsRepository.getList (for validateInvitationUUIDAndCreateUserGardenRecord)
      when(
        () => mockInvitationsRepository.getList(
          expand: InvitationField.garden,
          filter: any(named: "filter"), // use filter because of internal DateTime.now() call
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getOpenInvitationRecordModel(
            invitation: openInvitation,
            expandFields: [
              InvitationField.creator, InvitationField.invitee, InvitationField.garden
            ]
          ),
        ])
      );

      // UserGardenRecordsRepository.create
      when(
        () => mockUserGardenRecordsRepository.create(
          body: {
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
            user: user
          )
        ), {})
      );

      // mockInvitationsRepository.getList () (for getInvitationsByInvitee())
      when(
        () => mockInvitationsRepository.getList(
          expand: ""
            "${InvitationField.creator}, ${InvitationField.invitee}, ${InvitationField.garden}",
          filter: any(named: "filter"), // use filter because of internal DateTime.now() call
          sort: "${GenericField.created}, ${InvitationField.expiryDate}",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden1,
              type: InvitationType.private,
              invitee: user,
            ),
            expandFields: [
              InvitationField.creator, InvitationField.invitee, InvitationField.garden
            ]
          ),
          getPrivateInvitationRecordModel(
            invitation: InvitationFactory(
              garden: garden2,
              type: InvitationType.private,
              invitee: user,
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
        userID: garden1.id,
        returnValue: getUserRecordModel(user: garden1.creator)
      );
      users_repository.getFirstListItemStub(
        mockUsersRepository: mockUsersRepository,
        userID: garden2.id,
        returnValue: getUserRecordModel(user: garden2.creator)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageInvitationsTab(),
          ),
        )
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);

      // Enter the uuid of tc.openInvitation (pumpAndSettle to allow setState())
      await tester.enterText(
        find.byType(TextField), openInvitation.uuid!,
      );
      await tester.pumpAndSettle();

      // Tap on the submit button
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);

      // UserGardenRecordsRepository.create. Returns a non-empty errorsMap now
      when(
        () => mockUserGardenRecordsRepository.create(
          body: {
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
        ), {"error": "error"})
      );

      // Check error message not yet displayed
      expect(find.text(InvitationsText.createUserGardenRecordError), findsNothing);

      // Enter the uuid of tc.openInvitation (pumpAndSettle to allow setState())
      await tester.enterText(
        find.byType(TextField), openInvitation.uuid!,
      );
      await tester.pumpAndSettle();

      // Tap on the submit button
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Should display error message now (because UserGardenRecordsRepository.create
      // returns a non-empty errorsMap)
      expect(find.text(InvitationsText.createUserGardenRecordError), findsOneWidget);

    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("snapshot.data.isEmpty", (tester) async {
      final user = AppUserFactory();

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );

      // mockInvitationsRepository.getList. Returns empty list
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
        (_) async => ResultList<RecordModel>(items: [])
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageInvitationsTab(),
          ),
        )
      );

      await tester.pumpAndSettle();

      // Check widgets are rendered
      expect(find.byType(AppDialogCategoryHeader), findsNWidgets(1));
      expect(find.byType(OpenInvitationCodeTextField), findsOneWidget);
      expect(find.byType(PrivateInvitationsListView), findsOneWidget);
      expect(find.byType(LandingPageInvitationTile), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("snapshot.hasError", (tester) async {
      final errorMessage = "an error is thrown!";

      final user = AppUserFactory();

      final expiryDateThreshold = DateTime.now();
      final expiryDateThresholdString =
        DateFormat(Formats.dateYMMdd).format(expiryDateThreshold);

      final appState = AppState.skipSubscribe()
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );

      // mockInvitationsRepository.getList. Returns empty list
      when(
        () => mockInvitationsRepository.getList(
          expand: ""
            "${InvitationField.creator}, ${InvitationField.invitee}, ${InvitationField.garden}",
          filter: ""
            "${InvitationField.invitee} = '${user.id}' "
            "&& ${InvitationField.expiryDate} > '$expiryDateThresholdString'",
          sort: "${GenericField.created}, ${InvitationField.expiryDate}",
        )
      ).thenThrow(
        Exception(errorMessage)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageInvitationsTab(),
          ),
        )
      );

      await tester.pumpAndSettle();

      // Check widgets are rendered
      expect(find.byType(AppDialogCategoryHeader), findsNWidgets(2));
      expect(find.byType(OpenInvitationCodeTextField), findsOneWidget);
      expect(find.byType(PrivateInvitationsListView), findsOneWidget);
      expect(find.byType(LandingPageInvitationTile), findsNothing);

      expect(find.text("Exception: $errorMessage"), findsOneWidget);

    });

    tearDown(() => GetIt.instance.reset());
  });
}