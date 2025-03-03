import 'package:test/test.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

void main() {
  group("AppUserGardenRecord test", () {
    test("constructor", () {
      var user = AppUser(
        email: "test@user.com",
        id: "TESTUSER1",
        username: "testuser1",
      );
      var garden = Garden(
        creator: user,
        id: "TESTGARDEN1",
        name: "The Test Garden",
      );

      var gardenRecord = AppUserGardenRecord(
        id: "TESTGARDENRECORD1",
        user: user,
        garden: garden
      );

      expect(gardenRecord.id == "TESTGARDENRECORD1", true);
      expect(gardenRecord.user == user, true);
      expect(gardenRecord.garden == garden, true);
    });
  });
}