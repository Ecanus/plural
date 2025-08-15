import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

// Test
import '../../../test_factories.dart';
import '../../../test_mocks.dart';

void main() {
  group("AppUser test", () {
    test("constructor", () {
      final user = AppUserFactory(
        firstName: "FirstName2",
        id: "TESTUSER2",
        lastName: "LastName2",
        username: "testuser2"
      );

      expect(user.id == "TESTUSER2", true);
      expect(user.username == "testuser2", true);
    });

    test("hasRole", () async {
      final user = AppUserFactory();
      final garden = GardenFactory();

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();

      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // UserGardenRecordsRepository.getList(). Role of member
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: AppUserGardenRecordFactory(
                garden: garden,
                role: AppUserGardenRole.member,
                user: user,
              )
            )
          ]
        )
      );

      // Check user is member and no higher
      expect(await user.hasRole(garden.id, AppUserGardenRole.member), true);
      expect(await user.hasRole(garden.id, AppUserGardenRole.administrator), false);
      expect(await user.hasRole(garden.id, AppUserGardenRole.owner), false);

      // UserGardenRecordsRepository.getList(). Role of administrator
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: AppUserGardenRecordFactory(
                garden: garden,
                role: AppUserGardenRole.administrator,
                user: user,
              )
            )
          ]
        )
      );

      // Check user is administrator and no higher
      expect(await user.hasRole(garden.id, AppUserGardenRole.member), true);
      expect(await user.hasRole(garden.id, AppUserGardenRole.administrator), true);
      expect(await user.hasRole(garden.id, AppUserGardenRole.owner), false);

      // UserGardenRecordsRepository.getList(). Role of owner
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: AppUserGardenRecordFactory(
                garden: garden,
                role: AppUserGardenRole.owner,
                user: user,
              )
            )
          ]
        )
      );

      // Check user is owner
      expect(await user.hasRole(garden.id, AppUserGardenRole.member), true);
      expect(await user.hasRole(garden.id, AppUserGardenRole.administrator), true);
      expect(await user.hasRole(garden.id, AppUserGardenRole.owner), true);

      // UserGardenRecordsRepository.getList(). No record (or role) found
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: []
        )
      );

      // Check user is not a member
      expect(await user.hasRole(garden.id, AppUserGardenRole.member), false);
      expect(await user.hasRole(garden.id, AppUserGardenRole.administrator), false);
      expect(await user.hasRole(garden.id, AppUserGardenRole.owner), false);
    });

    tearDown(() => GetIt.instance.reset());

    test("==", () {
      final user = AppUserFactory();

      // Identity
      expect(user == user, true);

      final otherUserSameIDAndUsername = AppUserFactory.uncached(
        firstName: "OtherSameIDAndEmailFirst",
        id: user.id,
        lastName: "OtherSameIDAndEmailLast",
        username: user.username
      );

      expect(user == otherUserSameIDAndUsername, true);

      final otherUserDifferentIDAndUsername = AppUserFactory.uncached(
        firstName: "OtherFirst",
        id: "TESTUSER2",
        lastName: "OtherLast",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentIDAndUsername, false);

      final otherUserSameIDAndDifferentUsername = AppUserFactory.uncached(
        firstName: "OtherSameIDEmailDiffFirst",
        lastName: "OtherSameIDEmailDiffLast",
        id: user.id,
        username: "testotheruser"
      );

      expect(user == otherUserSameIDAndDifferentUsername, false);

      final otherUserDifferentIDAndSameUsername = AppUserFactory.uncached(
        firstName: "OtherDiffIDSameEmailFirst",
        lastName: "OtherDiffIDSameEmailLast",
        id: "TESTUSER2",
        username: user.username
      );

      expect(user == otherUserDifferentIDAndSameUsername, false);
    });

    test("toString", () {
      final user = AppUserFactory(
        id: "testUser",
        username: "theTestestOfUsers"
      );
      var string = "AppUser(id: testUser, username: theTestestOfUsers)";

      expect(user.toString(), string);
    });
  });
}