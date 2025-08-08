import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitation_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("AdminListedInvitationTile", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      final appState = AppState.skipSubscribe()
        ..currentGarden = tc.garden
        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(
        () => AppDialogViewRouter()
      );
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository
      );
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // InvitationsRepository.delete()
      when(
        () => mockInvitationsRepository.delete(
          id: tc.privateInvitation.id,
        )
      ).thenAnswer(
        (_) async => {}
      );

      // InvitationsRepository.getList()
      when(
        () => mockInvitationsRepository.getList(
          expand: "${InvitationField.creator}, ${InvitationField.invitee}",
          filter: any(named: "filter"), // use any because of internal DateTime.now() call
          sort: GenericField.created
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [
          tc.getOpenInvitationRecordModel(
            expand: [InvitationField.creator, InvitationField.invitee]
          ),
          tc.getPrivateInvitationRecordModel(
            expand: [InvitationField.creator, InvitationField.invitee]
          ),
        ])
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                AdminListedInvitationTile(invitation: tc.openInvitation),
                AdminListedInvitationTile(invitation: tc.privateInvitation),
              ],
            )
          ),
        )
      );

      expect(find.text(tc.openInvitation.uuid!), findsOneWidget);
      expect(find.text(tc.privateInvitation.invitee!.username), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(3)); // two expire Invitation buttons, one copy to clipboard button

      // Tap Icons.delete (to open dialog)
      await tester.tap(find.byIcon(Icons.delete).last);
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmExpireInvitationDialog), findsOneWidget);

      // Tap FilledButton to call deleteInvitation()
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}