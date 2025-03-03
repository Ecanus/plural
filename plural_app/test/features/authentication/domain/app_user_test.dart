import 'package:test/test.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

void main() {
  group("AppUser test", () {
    var user = AppUser(
      email: "test@user.com",
      id: "TESTUSER1",
      username: "testuser1",
    );

    test("constructor", () {
      expect(user.email == "test@user.com", true);
      expect(user.id == "TESTUSER1", true);
      expect(user.username == "testuser1", true);
    });

    test("==", () {
      // Identity
      expect(user == user, true);

      var otherUserSameID = AppUser(
        email: user.email,
        id: user.id,
        username: "testotheruser"
      );

      expect(user == otherUserSameID, true);

      var otherUserDifferentID = AppUser(
        email: "test@otheruser.com",
        id: "TESTUSER2",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentID, false);
    });

    test("toString", () {
      var string = "AppUser(id: TESTUSER1, username: testuser1, email: test@user.com)";

      expect(user.toString(), string);
    });
  });
}