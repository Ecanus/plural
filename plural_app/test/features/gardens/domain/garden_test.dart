import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

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

    test("toMap", () {
      final tc = TestContext();

      final gardenToMap = Garden(
        creator: tc.user,
        id: "TESTGARDEN2",
        name: "Rosemaries",
      );

      final map = {
        GardenField.creator: "TESTUSER1",
        GenericField.id: "TESTGARDEN2",
        GardenField.name: "Rosemaries"
      };

      expect(gardenToMap.toMap(), map);
    });

    test("emptyMap", () {
      final emptyMap = {
        GardenField.creator: null,
        GenericField.id: null,
        GardenField.name: null
      };

      expect(Garden.emptyMap(), emptyMap);
    });
  });
}