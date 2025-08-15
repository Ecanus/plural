import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("AppUserGardenRecord", () {
    test("constructor", () {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        id: "TestUserGardenRecord",
        user: user,
      );

      expect(userGardenRecord.id == "TestUserGardenRecord", true);
      expect(userGardenRecord.user == user, true);
      expect(userGardenRecord.garden == garden, true);
    });

    test("fromJson", () {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final record = {
        UserGardenRecordField.doDocumentReadDate: "2000-01-31",
        GenericField.id: "TESTUSERGARDENRECORD",
        UserGardenRecordField.role: "member"
      };
      final newUserGardenRecord = AppUserGardenRecord.fromJson(record, user, garden);

      expect(newUserGardenRecord.garden == garden, true);
      expect(newUserGardenRecord.doDocumentReadDate, DateTime(2000, 1, 31));
      expect(newUserGardenRecord.id == "TESTUSERGARDENRECORD", true);
      expect(newUserGardenRecord.role == AppUserGardenRole.member, true);
      expect(newUserGardenRecord.user == user, true);
    });

    test("hasReadDoDocument", () {
      final now = DateTime.now();

      final garden1 = GardenFactory(doDocumentEditDate: now);
      final userGardenRecord1 = AppUserGardenRecordFactory(
        doDocumentReadDate: now.add(Duration(days: -1)),
        garden: garden1,
      );

      // check hasReadDoDocument is false because doDocumentReadDate is earlier
      // than garden.doDocumentEditDate
      expect(userGardenRecord1.hasReadDoDocument, false);

      final userGardenRecord2 = AppUserGardenRecordFactory(
        id: "userGardenRecord2",
        doDocumentReadDate: now.add(Duration(days: 2)),
        garden: garden1,
      );

      // check hasReadDoDocument is true because doDocumentReadDate is later
      // than garden.doDocumentEditDate
      expect(userGardenRecord2.hasReadDoDocument, true);
    });

    test("toMap", () {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        id: "TESTGARDENRECORD1",
        user: user,
      );

      final userGardenRecordMap = {
        UserGardenRecordField.garden: garden.id,
        UserGardenRecordField.doDocumentReadDate: userGardenRecord.doDocumentReadDate,
        GenericField.id: "TESTGARDENRECORD1",
        UserGardenRecordField.role: "member",
        UserGardenRecordField.user: user.id,
      };

      expect(userGardenRecord.toMap(), userGardenRecordMap);
    });

    test("==", () {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        user: user
      );

      final differentUser = AppUserFactory();
      final differentGarden = GardenFactory(
        creator: differentUser,
        doDocument: "Do Document Test. No alarm.",
        doDocumentEditDate: DateTime.now(),
        id: "testDifferentGardenID",
        name: "testDifferentGardenName"
      );

      // Identity
      expect(userGardenRecord == userGardenRecord, true);

      // Different ID, Same Garden, Same User
      final differentIDSameGardenSameUser = AppUserGardenRecordFactory(
        id: "testDifferentID1",
        garden: garden,
        doDocumentReadDate: DateTime.now(),
        user: user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDSameGardenSameUser, false);

      // Different ID, Different Garden, Same User
      final differentIDDifferentGardenSameUser = AppUserGardenRecordFactory(
        id: "testDifferentID2",
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDDifferentGardenSameUser, false);

      // Different ID, Different Garden, Different User
      final differentIDDifferentGardenDifferentUser = AppUserGardenRecordFactory(
        id: "testDifferentID3",
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDDifferentGardenDifferentUser, false);

      // Same ID, Different Garden, Different User
      final sameIDDifferentGardenDifferentUser = AppUserGardenRecordFactory.uncached(
        id: userGardenRecord.id,
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDDifferentGardenDifferentUser, false);

      // Same ID, Same Garden, Different User
      final sameIDSameGardenDifferentUser = AppUserGardenRecordFactory.uncached(
        id: userGardenRecord.id,
        garden: garden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDSameGardenDifferentUser, false);

      // Same ID, Different Garden, Same User
      final sameIDDifferentGardenSameUser = AppUserGardenRecordFactory.uncached(
        id: userGardenRecord.id,
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDDifferentGardenSameUser, false);
    });

    test("toString", () {
      final userGardenRecord = AppUserGardenRecordFactory();

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