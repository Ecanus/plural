import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/presentation/landing_page_invitation_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Test
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("LandingPageInvitationTile", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                LandingPageInvitationTile(
                  invitation: tc.openInvitation,
                  setStateCallback: () {},
                ),
              ],
            )
          ),
        )
      );

      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets("setStateCallback", (tester) async {
      final list = [1, 2, 3];

      final tc = TestContext();

      final appState = AppState.skipSubscribe()
        ..currentUser = tc.user;

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
        () => mockInvitationsRepository.delete(id: tc.openInvitation.id)
      ).thenAnswer(
        (_) async => {}
      );

      // UserGardenRecordsRepository.create
      when(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.garden: tc.openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: GetIt.instance<AppState>().currentUser!.id,
          }
        )
      ).thenAnswer(
        (_) async => (tc.getUserGardenRecordRecordModel(), {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                LandingPageInvitationTile(
                  invitation: tc.openInvitation,
                  setStateCallback: () => list.clear(),
                ),
              ],
            )
          ),
        )
      );

      // Check list is still empty; methods not yet called
      expect(list.isEmpty, false);
      verifyNever(
        () => mockInvitationsRepository.delete(id: tc.openInvitation.id)
      );
      verifyNever(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.garden: tc.openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: GetIt.instance<AppState>().currentUser!.id,
          }
        )
      );

      // Tap Icons.check (to accept Invitation)
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Check list is now empty. Methods were called
      expect(list.isEmpty, true);
      verify(
        () => mockInvitationsRepository.delete(id: tc.openInvitation.id)
      ).called(1);
      verify(
        () => mockUserGardenRecordsRepository.create(
          body: {
            UserGardenRecordField.garden: tc.openInvitation.garden.id,
            UserGardenRecordField.role: AppUserGardenRole.member.name,
            UserGardenRecordField.user: GetIt.instance<AppState>().currentUser!.id,
          }
        )
      ).called(1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                LandingPageInvitationTile(
                  invitation: tc.openInvitation,
                  setStateCallback: () => list.addAll([1, 2, 3, 4]),
                ),
              ],
            )
          ),
        )
      );

      expect(list.isEmpty, true);

      // Tap Icons.clear (to decline Invitation)
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(list.length, 4);
    });
  });
}