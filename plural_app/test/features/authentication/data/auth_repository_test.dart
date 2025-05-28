import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Auth repository test", () {
    test("getUserGardenRecord", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      // GetIt
      getIt.registerLazySingleton<AuthRepository>(
        () => authRepository
      );
      getIt.registerLazySingleton<GardensRepository>(
        () => GardensRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userGardenRecords)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.gardens)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.garden.id}'")
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel()
      );
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // RecordService.getList(), empty list
      when(
        () => recordService.getList(
          filter: "user = '${tc.user.id}' && garden = '${tc.garden.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      var nullRecord = await authRepository.getUserGardenRecord(
        userID: tc.user.id, gardenID: tc.garden.id);
      expect(nullRecord, null);

      // RecordService.getList()
      when(
        () => recordService.getList(
          filter: "user = '${tc.user.id}' && garden = '${tc.garden.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getGardenRecordRecordModel()])
      );

      var record = await authRepository.getUserGardenRecord(
        userID: tc.user.id, gardenID: tc.garden.id);
      expect(record!, isA<AppUserGardenRecord>());
      expect(record.id, "TESTGARDENRECORD1");
      expect(record.user, tc.user);
      expect(record.garden, tc.garden);
    });

    tearDown(() => GetIt.instance.reset());

    test("getCurrentGardenUsers", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      final AppState appState = AppState.skipSubscribe()
                                ..currentGarden = tc.garden;

      // GetIt
      getIt.registerLazySingleton<AppState>(
        () => appState
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userGardenRecords)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          expand: UserGardenRecordField.user,
          filter: "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.user)])
      );

      var users = await authRepository.getCurrentGardenUsers();
      expect(users.length, 1);

      var thisUser = users.first;
      expect(thisUser, isA<AppUser>());
      expect(thisUser.id, tc.user.id);
      expect(thisUser.email, tc.user.email);
      expect(thisUser.username, tc.user.username);
    });

    tearDown(() => GetIt.instance.reset());

    test("getUserByID", () async {
      final tc = TestContext();
      final pb = MockPocketBase();

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var thisUser = await authRepository.getUserByID(tc.user.id);

      expect(thisUser, isA<AppUser>());
      expect(thisUser.id, "TESTUSER1");
      expect(thisUser.email, "test@user.com");
      expect(thisUser.username, "testuser");
    });

    test("getCurrentUserSettings", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);
      final AppState appState = AppState();

      appState.currentUser = tc.user;

      // GetIt
      getIt.registerLazySingleton<AppState>(
        () => appState
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      var thisUser = await authRepository.getUserByID(tc.user.id);

      expect(thisUser, isA<AppUser>());
      expect(thisUser.id, "TESTUSER1");
      expect(thisUser.email, "test@user.com");
      expect(thisUser.username, "testuser");
    });

    test("updateUserSettings", () async {
      final tc = TestContext();
      final pb = MockPocketBase();

      final recordService = MockRecordService();
      final authRepository = AuthRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var map = {
        GenericField.id: "",
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
      };

      var (updateStatus1, errorsMap1) = await authRepository.updateUserSettings(map);
      expect(updateStatus1, true);
      expect(errorsMap1.isEmpty, true);

      // RecordService.update(), throw exception
      when(
        () => recordService.update(any(), body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      var (updateStatus2, errorsMap2) = await authRepository.updateUserSettings(map);
      expect(updateStatus2, false);
      expect(errorsMap2.isEmpty, false);
    });
  });
}