import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("Garden test", () {
    test("constructor", () {
      final tc = TestContext();

      expect(tc.garden.creator == tc.user, true);
      expect(tc.garden.id == "TESTGARDEN1", true);
      expect(tc.garden.name == "Petunia", true);
    });

    test("fromJson", () {
      final tc = TestContext();

      final record = {
        GenericField.id: "TESTGARDENFROMJSON",
        GardenField.name: "Daisies"
      };
      final newGarden = Garden.fromJson(record, tc.user);

      expect(newGarden.creator == tc.user, true);
      expect(newGarden.id == "TESTGARDENFROMJSON", true);
      expect(newGarden.name == "Daisies", true);
    });

    test("toMap", () {
      final tc = TestContext();

      final garden = Garden(
        creator: tc.user,
        id: "TESTGARDEN2",
        name: "Rosemaries",
      );

      final map = {
        GardenField.creator: "TESTUSER1",
        GenericField.id: "TESTGARDEN2",
        GardenField.name: "Rosemaries"
      };

      expect(garden.toMap(), map);
    });

    test("emptyMap", () {
      final emptyMap = {
        GardenField.creator: null,
        GenericField.id: null,
        GardenField.name: null
      };

      expect(Garden.emptyMap(), emptyMap);
    });

    test("==", () {
      final tc = TestContext();
      final garden = tc.garden;

      final differentUser = AppUser(
        firstName: "testFirstName",
        id: "testID",
        lastName: "testLastName",
        username: "testUsername",
      );

      // Identity
      expect(garden == garden, true);

      // Same ID
      final sameIDgarden = Garden(
        creator: differentUser,
        id: garden.id,
        name: "sameIDGarden"
      );

      expect(garden == sameIDgarden, true);

      // Different ID
      final differentIDGarden = Garden(
        creator: tc.user,
        id: "differentIDGarden",
        name: tc.garden.name,
      );

      expect(garden == differentIDGarden, false);
    });

    test("toString", () {
      final tc = TestContext();
      final garden = tc.garden;

      expect(
        garden.toString(),
        "Garden(id: ${garden.id}, name: ${garden.name}, creator: ${garden.creator})"
      );
    });
  });
}