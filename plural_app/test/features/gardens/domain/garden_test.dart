import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

void main() {
  group("Garden test", () {
    var user = AppUser(
      email: "test@user.com",
      id: "TESTUSER1",
      username: "testuser1",
    );

    var garden = Garden(
      creator: user,
      id: "TESTGARDEN1",
      name: "Sunflowers",
    );

    test("constructor", () {
      expect(garden.creator == user, true);
      expect(garden.id == "TESTGARDEN1", true);
      expect(garden.name == "Sunflowers", true);
    });

    test("toMap", () {
      var gardenToMap = Garden(
        creator: user,
        id: "TESTGARDEN2",
        name: "Rosemaries",
      );

      var map = {
        GardenField.creator: "TESTUSER1",
        GenericField.id: "TESTGARDEN2",
        GardenField.name: "Rosemaries"
      };

      expect(gardenToMap.toMap(), map);
    });

    test("emptyMap", () {
      var emptyMap = {
        GardenField.creator: null,
        GenericField.id: null,
        GardenField.name: null
      };

      expect(Garden.emptyMap(), emptyMap);
    });
  });
}