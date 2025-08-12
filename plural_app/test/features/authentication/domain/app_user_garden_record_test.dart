import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Garden
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AppUserGardenRecord", () {
    test("constructor", () {
      final tc = TestContext();

      expect(tc.userGardenRecord.id == "TESTGARDENRECORD1", true);
      expect(tc.userGardenRecord.user == tc.user, true);
      expect(tc.userGardenRecord.garden == tc.garden, true);
    });

    test("fromJson", () {
      final tc = TestContext();

      final record = {
        UserGardenRecordField.doDocumentReadDate: "2000-01-31",
        GenericField.id: "TESTUSERGARDENRECORD",
        UserGardenRecordField.role: "member"
      };
      final newUserGardenRecord = AppUserGardenRecord.fromJson(
        record, tc.user, tc.garden);

      expect(newUserGardenRecord.garden == tc.garden, true);
      expect(newUserGardenRecord.doDocumentReadDate, DateTime(2000, 1, 31));
      expect(newUserGardenRecord.id == "TESTUSERGARDENRECORD", true);
      expect(newUserGardenRecord.role == AppUserGardenRole.member, true);
      expect(newUserGardenRecord.user == tc.user, true);
    });

    test("hasReadDoDocument", () {
      final now = DateTime.now();

      final garden1 = TestGardenFactory(doDocumentEditDate: now);
      final userGardenRecord1 = TestAppUserGardenRecordFactory(
        doDocumentReadDate: now.add(Duration(days: -1)),
        garden: garden1,
      );

      final appState = AppState.skipSubscribe()
        ..currentGarden = userGardenRecord1.garden;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      // check hasReadDoDocument is false because doDocumentReadDate is earlier
      // than garden.doDocumentEditDate
      expect(userGardenRecord1.hasReadDoDocument, false);

      final userGardenRecord2 = TestAppUserGardenRecordFactory(
        id: "userGardenRecord2",
        doDocumentReadDate: now.add(Duration(days: 2)),
        garden: garden1,
      );

      // check hasReadDoDocument is true because doDocumentReadDate is later
      // than garden.doDocumentEditDate
      expect(userGardenRecord2.hasReadDoDocument, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("toMap", () {
      final tc = TestContext();
      final userGardenRecord = tc.userGardenRecord;

      final userGardenRecordMap = {
        UserGardenRecordField.garden: tc.garden.id,
        UserGardenRecordField.doDocumentReadDate: tc.userGardenRecord.doDocumentReadDate,
        GenericField.id: "TESTGARDENRECORD1",
        UserGardenRecordField.role: "member",
        UserGardenRecordField.user: tc.user.id,
      };

      expect(userGardenRecord.toMap(), userGardenRecordMap);
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
        doDocument: "Do Document Test. No alarm.",
        doDocumentEditDate: DateTime.now(),
        id: "testDifferentGardenID",
        name: "testDifferentGardenName"
      );

      // Identity
      expect(userGardenRecord == userGardenRecord, true);

      // Different ID, Same Garden, Same User
      final differentIDSameGardenSameUser = AppUserGardenRecord(
        id: "testDifferentID",
        garden: tc.garden,
        doDocumentReadDate: DateTime.now(),
        user: tc.user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDSameGardenSameUser, false);

      // Different ID, Different Garden, Same User
      final differentIDDifferentGardenSameUser = AppUserGardenRecord(
        id: "testDifferentID",
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: tc.user,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDDifferentGardenSameUser, false);

      // Different ID, Different Garden, Different User
      final differentIDDifferentGardenDifferentUser = AppUserGardenRecord(
        id: "testDifferentID",
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == differentIDDifferentGardenDifferentUser, false);

      // Same ID, Different Garden, Different User
      final sameIDDifferentGardenDifferentUser = AppUserGardenRecord(
        id: tc.userGardenRecord.id,
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDDifferentGardenDifferentUser, false);

      // Same ID, Same Garden, Different User
      final sameIDSameGardenDifferentUser = AppUserGardenRecord(
        id: tc.userGardenRecord.id,
        garden: tc.garden,
        doDocumentReadDate: DateTime(2000, 1, 31),
        user: differentUser,
        role: AppUserGardenRole.member
      );

      expect(userGardenRecord == sameIDSameGardenDifferentUser, false);

      // Same ID, Different Garden, Same User
      final sameIDDifferentGardenSameUser = AppUserGardenRecord(
        id: tc.userGardenRecord.id,
        garden: differentGarden,
        doDocumentReadDate: DateTime(2000, 1, 31),
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