import 'package:flutter_test/flutter_test.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

void main() {
  group("invitations_api", () {
    test("getInvitationTypeFromString", () {
      expect(getInvitationTypeFromString("open"), InvitationType.open);
      expect(getInvitationTypeFromString("private"), InvitationType.private);

      expect(getInvitationTypeFromString("invalidValue"), null);
    });
  });
}