import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("Invitation", () {
    test("constructor", () {
      final tc = TestContext();

      final dateTime = DateTime(2025, 12, 15);
      final uuid = Uuid().v1();

      final invitation = Invitation(
        creator: tc.user,
        createdDate: dateTime,
        expiryDate: dateTime.add(Duration(days: 10)),
        garden: tc.garden,
        id: "TESTINVITATION",
        type: InvitationType.open,
        uuid: uuid,
      );

      expect(invitation.creator, tc.user);
      expect(invitation.createdDate, dateTime);
      expect(invitation.expiryDate, DateTime(2025, 12, 25));
      expect(invitation.garden, tc.garden);
      expect(invitation.id, "TESTINVITATION");
      expect(invitation.type, InvitationType.open);
      expect(invitation.invitee, null);
      expect(invitation.uuid, uuid);
    });

    test("fromJson", () {
      final tc = TestContext();

      final invitee = AppUser(
        firstName: "inviteeFirstName",
        id: "inviteeID",
        lastName: "inviteeLastName",
        username: "the_invitee"
      );

      final dateTime = DateTime(2025, 12, 31);
      final expiryDateTime = dateTime.add(Duration(days: 10));

      final record = {
        GenericField.created: DateFormat(Formats.dateYMMddHHms).format(dateTime),
        InvitationField.expiryDate:
          DateFormat(Formats.dateYMMddHHms).format(expiryDateTime),
        GenericField.id: "TESTINVITATIONFROMJSON",
        InvitationField.type: InvitationType.private.name,
      };

      final invitation = Invitation.fromJson(record, tc.user, tc.garden, invitee);

      expect(invitation.creator, tc.user);
      expect(invitation.createdDate, dateTime);
      expect(invitation.expiryDate, DateTime(2026, 1, 10));
      expect(invitation.garden, tc.garden);
      expect(invitation.id, "TESTINVITATIONFROMJSON");
      expect(invitation.type, InvitationType.private);
      expect(invitation.invitee, invitee);
      expect(invitation.uuid, null);
    });

    test("asserts", () {
      final invitee = AppUser(
        firstName: "inviteeFirstName",
        id: "inviteeID",
        lastName: "inviteeLastName",
        username: "the_invitee"
      );

      final tc = TestContext();
      final dateTime = DateTime(2025, 12, 15);

      // AssertionError if both uuid and username are null (type == open)
      expect(
        () => Invitation(
          creator: tc.user,
          createdDate: dateTime,
          expiryDate: dateTime.add(Duration(days: 10)),
          garden: tc.garden,
          id: "TESTINVITATION",
          type: InvitationType.open,
          invitee: null,
          uuid: null,
        ),
        throwsA(predicate((e) => e is AssertionError))
      );

      // AssertionError if both uuid and username are null (type == private)
      expect(
        () => Invitation(
          creator: tc.user,
          createdDate: dateTime,
          expiryDate: dateTime.add(Duration(days: 10)),
          garden: tc.garden,
          id: "TESTINVITATION",
          type: InvitationType.private,
          invitee: null,
          uuid: null,
        ),
        throwsA(predicate((e) => e is AssertionError))
      );

      // AssertionError if both uuid and username are provided (type == open)
      expect(
        () => Invitation(
          creator: tc.user,
          createdDate: dateTime,
          expiryDate: dateTime.add(Duration(days: 10)),
          garden: tc.garden,
          id: "TESTINVITATION",
          type: InvitationType.open,
          invitee: invitee,
          uuid: "value2",
        ),
        throwsA(predicate((e) => e is AssertionError))
      );

      // AssertionError if both uuid and username are provided (type == private)
      expect(
        () => Invitation(
          creator: tc.user,
          createdDate: dateTime,
          expiryDate: dateTime.add(Duration(days: 10)),
          garden: tc.garden,
          id: "TESTINVITATION",
          type: InvitationType.private,
          invitee: invitee,
          uuid: "value2",
        ),
        throwsA(predicate((e) => e is AssertionError))
      );
    });

    test("emptyMap", () {
      expect(
        Invitation.emptyMap(),
        {
          InvitationField.creator: null,
          InvitationField.expiryDate: null,
          InvitationField.garden: null,
          InvitationField.type: null,
          InvitationField.invitee: null,
          InvitationField.uuid: null,
        }
      );
    });

    test("==", () {
      final tc = TestContext();

      final dateTime = DateTime(2025, 12, 15);
      final uuid = Uuid().v1();

      final invitation1 = Invitation(
        creator: tc.user,
        createdDate: dateTime,
        expiryDate: dateTime.add(Duration(days: 10)),
        garden: tc.garden,
        id: "TESTINVITATION1",
        type: InvitationType.open,
        uuid: uuid,
      );

      final invitation2 = Invitation(
        creator: tc.user,
        createdDate: dateTime,
        expiryDate: dateTime.add(Duration(days: 10)),
        garden: tc.garden,
        id: "TESTINVITATION2",
        type: InvitationType.open,
        uuid: uuid,
      );

      final invitation3 = Invitation(
        creator: tc.user,
        createdDate: dateTime,
        expiryDate: dateTime.add(Duration(days: 10)),
        garden: tc.garden,
        id: "TESTINVITATION1",
        type: InvitationType.open,
        uuid: uuid,
      );

      expect(invitation1 == invitation1, true);
      expect(invitation1 == invitation2, false);
      expect(invitation1 == invitation3, true);
    });

    test("==", () {
      final invitee = AppUser(
        firstName: "inviteeFirstName",
        id: "inviteeID",
        lastName: "inviteeLastName",
        username: "the_invitee"
      );

      final tc = TestContext();

      final dateTime = DateTime(2025, 12, 15);
      final uuid = Uuid().v1();

      final invitation1 = Invitation(
        creator: tc.user,
        createdDate: dateTime,
        expiryDate: dateTime.add(Duration(days: 10)),
        garden: tc.garden,
        id: "TESTINVITATION1",
        type: InvitationType.open,
        uuid: uuid,
      );

      final invitation2 = Invitation(
        creator: tc.user,
        createdDate: dateTime,
        expiryDate: dateTime.add(Duration(days: 10)),
        garden: tc.garden,
        id: "TESTINVITATION2",
        type: InvitationType.private,
        invitee: invitee,
      );

      expect(
        invitation1.toString(),
        ""
        "Invitation(id: TESTINVITATION1, garden: 'Petunia', "
        "creator: 'testuser', type: open, uuid: '$uuid')"
      );
      expect(
        invitation2.toString(),
        ""
        "Invitation(id: TESTINVITATION2, garden: 'Petunia', "
        "creator: 'testuser', type: private, invitee: 'the_invitee')"
      );
    });

    test("InvitationType entries", () {
      expect(InvitationType.entries[0].value, InvitationType.open);
      expect(InvitationType.entries[0].label, InvitationType.open.displayName);

      expect(InvitationType.entries[1].value, InvitationType.private);
      expect(InvitationType.entries[1].label, InvitationType.private.displayName);
    });
  });
}