import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("Garden", () {
    test("constructor", () {
      final user = AppUserFactory();
      final garden = GardenFactory(
        creator: user,
        id: "testGarden1",
        name: "Petunia",
      );

      expect(garden.creator == user, true);
      expect(garden.id == "testGarden1", true);
      expect(garden.name == "Petunia", true);
    });

    test("fromJson", () {
      final user = AppUserFactory();

      final record = {
        GardenField.doDocument: "Do Document!",
        GardenField.doDocumentEditDate: "2000-01-31",
        GenericField.id: "TESTGARDENFROMJSON",
        GardenField.name: "Daisies"
      };
      final newGarden = Garden.fromJson(record, user);

      expect(newGarden.creator == user, true);
      expect(newGarden.doDocument, "Do Document!");
      expect(newGarden.id == "TESTGARDENFROMJSON", true);
      expect(newGarden.name == "Daisies", true);
    });

    test("toMap", () {
      final user = AppUserFactory(
        id: "testCreator"
      );

      final garden = GardenFactory(
        creator: user,
        doDocument: "Test the Do Document",
        doDocumentEditDate: DateTime(2000, 1, 31),
        id: "TESTGARDEN2",
        name: "Rosemaries",
      );

      final map = {
        GardenField.creator: "testCreator",
        GardenField.doDocument: "Test the Do Document",
        GardenField.doDocumentEditDate: DateTime(2000, 1, 31),
        GenericField.id: "TESTGARDEN2",
        GardenField.name: "Rosemaries"
      };

      expect(garden.toMap(), map);
    });

    test("emptyMap", () {
      final emptyMap = {
        GardenField.creator: null,
        GardenField.doDocument: null,
        GardenField.doDocumentEditDate: null,
        GenericField.id: null,
        GardenField.name: null
      };

      expect(Garden.emptyMap(), emptyMap);
    });

    test("==", () {
      final user = AppUserFactory();
      final garden = GardenFactory(creator: user);

      final differentUser = AppUserFactory();

      // Identity
      expect(garden == garden, true);

      // Same ID
      final sameIDgarden = GardenFactory.uncached(
        creator: differentUser,
        id: garden.id,
      );

      expect(garden == sameIDgarden, true);

      // Different ID
      final differentIDGarden = GardenFactory.uncached(
        creator: user,
        id: "differentIDGarden"
      );

      expect(garden == differentIDGarden, false);
    });

    test("toString", () {
      final user = AppUserFactory(
        username: "theUserName"
      );
      final garden = GardenFactory(
        creator: user,
        id: "testToStringID",
        name: "Daffodils"
      );

      expect(
        garden.toString(),
        "Garden(id: 'testToStringID', name: 'Daffodils', creator: 'theUserName')"
      );
    });
  });
}