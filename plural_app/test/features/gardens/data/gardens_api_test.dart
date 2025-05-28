import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Gardens api test", () {
    test("getGardensByUser !excludeCurrentGarden", () async {
      final tc = TestContext();
      var appState = AppState.skipSubscribe()
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden),
            tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden),
            tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden),
          ]
        )
      );

      // getGardensByUser
      List<Garden> gardens = await getGardensByUser(
        tc.user.id, excludeCurrentGarden: false
      );

      // Check that 3 gardens created
      expect(gardens.length, 3);

      // Check that the correct filter was used
      verify(() => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    test("getGardensByUser excludeCurrentGarden", () async {
      final tc = TestContext();
      var appState = AppState.skipSubscribe()
        ..currentUser = tc.user
        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // UserGardenRecordsRepository.getList()
      when(
        () => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: ""
            "${UserGardenRecordField.garden}.${GenericField.id} != '${tc.garden.id}' && "
            "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden),
            tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden),
            tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden),
          ]
        )
      );

      // getGardensByUser
      List<Garden> gardens = await getGardensByUser(
        tc.user.id, excludeCurrentGarden: true
      );

      // Check 3 gardens created
      expect(gardens.length, 3);

      // Check that the correct filter was used
      verify(() => mockUserGardenRecordsRepository.getList(
          expand: any(named: "expand"),
          filter: ""
            "${UserGardenRecordField.garden}.${GenericField.id} != '${tc.garden.id}' && "
            "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"),
        )
      ).called(1);
    });

    tearDown(() => GetIt.instance.reset());
  });
}