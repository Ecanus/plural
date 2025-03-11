import 'package:test/test.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Test
import '../../../test_context.dart';

void main() {
  group("AppUser test", () {
    test("constructor", () {
      final tc = TestContext();
      final user = tc.user;

      expect(user.email == "test@user.com", true);
      expect(user.id == "TESTUSER1", true);
      expect(user.username == "testuser", true);
    });

    test("==", () {
      final tc = TestContext();
      final user = tc.user;

      // Identity
      expect(user == user, true);

      var otherUserSameIDAndEmail = AppUser(
        email: user.email,
        id: user.id,
        username: "testotheruser"
      );

      expect(user == otherUserSameIDAndEmail, true);

      var otherUserDifferentID = AppUser(
        email: "test@otheruser.com",
        id: "TESTUSER2",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentID, false);
    });

    test("toString", () {
      final tc = TestContext();
      var string = "AppUser(id: TESTUSER1, username: testuser, email: test@user.com)";

      expect(tc.user.toString(), string);
    });
  });
}