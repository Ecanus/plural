import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Invitations
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitation_tile.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AdminListedInvitationTile", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

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

      // Tap Icons.event_busy (to open dialog)
      await tester.tap(find.byIcon(Icons.event_busy).last);
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmExpireInvitationDialog), findsOneWidget);
    });
  });
}