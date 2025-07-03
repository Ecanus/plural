import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Garden
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AppUserGardenRecord test", () {
    test("constructor", () {
      final tc = TestContext();

      expect(tc.userGardenRecord.id == "TESTGARDENRECORD1", true);
      expect(tc.userGardenRecord.user == tc.user, true);
      expect(tc.userGardenRecord.garden == tc.garden, true);
    });

    test("fromJson", () {
      final tc = TestContext();

      final record = {
        GenericField.id: "TESTUSERGARDENRECORD",
        UserGardenRecordField.role: "member"
      };
      final newUserGardenRecord = AppUserGardenRecord.fromJson(
        record, tc.user, tc.garden);

      expect(newUserGardenRecord.garden == tc.garden, true);
      expect(newUserGardenRecord.id == "TESTUSERGARDENRECORD", true);
      expect(newUserGardenRecord.role == AppUserGardenRole.member, true);
      expect(newUserGardenRecord.user == tc.user, true);
    });

    test("==", () {
      final tc = TestContext();
      final userGardenRecord = tc.userGardenRecord;

      final differentUser = AppUser(
        firstName: "testFirstName",
        id: "testID",
        lastName: "testLastName",
        username: "testUsername",
      );

      final differentGarden = Garden(
        creator: differentUser,
        id: "testDifferentGardenID",
        name: "testDifferentGardenName"
      );

      // Identity
      expect(userGardenRecord == userGardenRecord, true);

      // Different ID, Same Garden, Same User
      final differentIDSameGardenSameUser = AppUserGardenRecord(
        id: "testDifferentID",
        garden: tc.garden,
        user: tc.user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDSameGardenSameUser, false);

      // Different ID, Different Garden, Same User
      final differentIDDifferentGardenSameUser = AppUserGardenRecord(
        id: "testDifferentID",
        garden: differentGarden,
        user: tc.user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDDifferentGardenSameUser, false);

      // Different ID, Different Garden, Different User
      final differentIDDifferentGardenDifferentUser = AppUserGardenRecord(
        id: "testDifferentID",
        garden: differentGarden,
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDDifferentGardenDifferentUser, false);

      // Same ID, Different Garden, Different User
      final sameIDDifferentGardenDifferentUser = AppUserGardenRecord(
        id: tc.userGardenRecord.id,
        garden: differentGarden,
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDDifferentGardenDifferentUser, false);

      // Same ID, Same Garden, Different User
      final sameIDSameGardenDifferentUser = AppUserGardenRecord(
        id: tc.userGardenRecord.id,
        garden: tc.garden,
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDSameGardenDifferentUser, false);

      // Same ID, Different Garden, Same User
      final sameIDDifferentGardenSameUser = AppUserGardenRecord(
        id: tc.userGardenRecord.id,
        garden: differentGarden,
        user: tc.user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDDifferentGardenSameUser, false);
    });

    test("toString", () {
      final tc = TestContext();
      final userGardenRecord = tc.userGardenRecord;

      expect(
        userGardenRecord.toString(),
        ""
        "AppUserGardenRecord(id: ${userGardenRecord.id}, "
        "user: ${userGardenRecord.user.id}, "
        "garden: ${userGardenRecord.garden.id}, "
        "role: ${userGardenRecord.role.toString()})"
      );
    });
  });
}