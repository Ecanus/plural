import 'package:test/test.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Test
import '../../../test_context.dart';

void main() {
  group("AppUser test", () {
    test("constructor", () {
      final user = AppUser(
        email: "test2@user.com",
        firstName: "FirstName2",
        id: "TESTUSER2",
        lastName: "LastName2",
        username: "testuser2"
      );

      expect(user.email == "test2@user.com", true);
      expect(user.id == "TESTUSER2", true);
      expect(user.username == "testuser2", true);
    });

    test("==", () {
      final tc = TestContext();
      final user = tc.user;

      // Identity
      expect(user == user, true);

      final otherUserSameIDAndEmail = AppUser(
        email: user.email,
        firstName: "OtherSameIDAndEmailFirst",
        id: user.id,
        lastName: "OtherSameIDAndEmailLast",
        username: "testotheruser"
      );

      expect(user == otherUserSameIDAndEmail, true);

      final otherUserDifferentIDAndEmail = AppUser(
        email: "test@otheruser.com",
        firstName: "OtherFirst",
        id: "TESTUSER2",
        lastName: "OtherLast",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentIDAndEmail, false);

      final otherUserSameIDAndDifferentEmail = AppUser(
        email: "test@otheruser.com",
        firstName: "OtherSameIDEmailDiffFirst",
        lastName: "OtherSameIDEmailDiffLast",
        id: user.id,
        username: "testotheruser"
      );

      expect(user == otherUserSameIDAndDifferentEmail, false);

      final otherUserDifferentIDAndSameEmail = AppUser(
        email: user.email,
        firstName: "OtherDiffIDSameEmailFirst",
        lastName: "OtherDiffIDSameEmailLast",
        id: "TESTUSER2",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentIDAndSameEmail, false);
    });

    test("toString", () {
      final tc = TestContext();
      var string = "AppUser(id: TESTUSER1, username: testuser, email: test@user.com)";

      expect(tc.user.toString(), string);
    });
  });
}