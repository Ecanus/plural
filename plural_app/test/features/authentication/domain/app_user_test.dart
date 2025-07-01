import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Test
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("AppUser test", () {
    test("constructor", () {
      final user = AppUser(
        email: "test2@user.com",
        firstName: "FirstName2",
        id: "TESTUSER2",
        lastName: "LastName2",
        username: "testuser2"
      );

      expect(user.email == "test2@user.com", true);
      expect(user.id == "TESTUSER2", true);
      expect(user.username == "testuser2", true);
    });

    test("hasRole", () async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getUserGardenRecordRecordModel()]
        )
      );

      // GardensRepository.getFirstListItem()
      when(
        () => mockGardensRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.garden.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel()
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: "${GenericField.id} = '${tc.user.id}'",
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // Check user is member and no higher
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.member), true);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.moderator), false);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.owner), false);

      // UserGardenRecordsRepository.getList(). Role of moderator
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.moderator)]
        )
      );

      // Check user is moderator and no higher
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.member), true);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.moderator), true);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.owner), false);

      // UserGardenRecordsRepository.getList(). Role of owner
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.owner)]
        )
      );

      // Check user is owner
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.member), true);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.moderator), true);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.owner), true);

      // UserGardenRecordsRepository.getList(). No record (or role) found
      when(
        () => mockUserGardenRecordsRepository.getList(
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated"
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: []
        )
      );

      // Check user is not a member
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.member), false);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.moderator), false);
      expect(await tc.user.hasRole(tc.garden.id, AppUserGardenRole.owner), false);
    });

    tearDown(() => GetIt.instance.reset());

    test("==", () {
      final tc = TestContext();
      final user = tc.user;

      // Identity
      expect(user == user, true);

      final otherUserSameIDAndEmail = AppUser(
        email: user.email,
        firstName: "OtherSameIDAndEmailFirst",
        id: user.id,
        lastName: "OtherSameIDAndEmailLast",
        username: "testotheruser"
      );

      expect(user == otherUserSameIDAndEmail, true);

      final otherUserDifferentIDAndEmail = AppUser(
        email: "test@otheruser.com",
        firstName: "OtherFirst",
        id: "TESTUSER2",
        lastName: "OtherLast",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentIDAndEmail, false);

      final otherUserSameIDAndDifferentEmail = AppUser(
        email: "test@otheruser.com",
        firstName: "OtherSameIDEmailDiffFirst",
        lastName: "OtherSameIDEmailDiffLast",
        id: user.id,
        username: "testotheruser"
      );

      expect(user == otherUserSameIDAndDifferentEmail, false);

      final otherUserDifferentIDAndSameEmail = AppUser(
        email: user.email,
        firstName: "OtherDiffIDSameEmailFirst",
        lastName: "OtherDiffIDSameEmailLast",
        id: "TESTUSER2",
        username: "testotheruser"
      );

      expect(user == otherUserDifferentIDAndSameEmail, false);
    });

    test("toString", () {
      final tc = TestContext();
      var string = "AppUser(id: TESTUSER1, username: testuser, email: test@user.com)";

      expect(tc.user.toString(), string);
    });
  });
}