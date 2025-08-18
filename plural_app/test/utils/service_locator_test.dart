import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/service_locator.dart';

// Tests
import '../test_factories.dart';
import '../test_mocks.dart';
import '../test_record_models.dart';

void main() {
  group("Service locator test", () {
    test("registerGetItInstances", () async {
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      final pb = MockPocketBase();
      final recordService = MockRecordService();

      final getIt = GetIt.instance;

      // pb.authStore
      final authStore = AuthStore();
      authStore.save("newToken", getUserRecordModel(user: user));
      when(
        () => pb.authStore
      ).thenReturn(
        authStore
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${user.id}'")
      ).thenAnswer(
        (_) async => getUserRecordModel(user: user)
      );
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${user.id}'")
      ).thenAnswer(
        (_) async => getUserSettingsRecordModel(
          userSettings: userSettings
        )
      );

      // Check values not yet registered
      expect(getIt.isRegistered<PocketBase>(), false);
      expect(getIt.isRegistered<AppDialogViewRouter>(), false);
      expect(getIt.isRegistered<AsksRepository>(), false);
      expect(getIt.isRegistered<UserGardenRecordsRepository>(), false);
      expect(getIt.isRegistered<UserSettingsRepository>(), false);
      expect(getIt.isRegistered<UsersRepository>(), false);
      expect(getIt.isRegistered<GardensRepository>(), false);
      expect(getIt.isRegistered<AppState>(), false);

      await registerGetItInstances(pb);

      // Check values are registered
      expect(getIt.isRegistered<PocketBase>(), true);
      expect(getIt.isRegistered<AppDialogViewRouter>(), true);
      expect(getIt.isRegistered<AsksRepository>(), true);
      expect(getIt.isRegistered<UserGardenRecordsRepository>(), true);
      expect(getIt.isRegistered<UserSettingsRepository>(), true);
      expect(getIt.isRegistered<UsersRepository>(), true);
      expect(getIt.isRegistered<GardensRepository>(), true);

      expect(getIt.isRegistered<AppState>(), true);
      expect(getIt<AppState>().currentUser,user);
      expect(getIt<AppState>().currentUserSettings, userSettings);
    });

    tearDown(() => GetIt.instance.reset());

    test("clearGetItInstance", () async {
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      // GetIt
      getIt.registerLazySingleton<PocketBase>(
        () => pb
      );
      getIt.registerLazySingleton<AppDialogViewRouter>(
        () => AppDialogViewRouter()
      );
      getIt.registerLazySingleton<AsksRepository>(
        () => AsksRepository(pb: pb)
      );
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => UserGardenRecordsRepository(pb: pb)
      );
      getIt.registerLazySingleton<UserSettingsRepository>(
        () => UserSettingsRepository(pb: pb)
      );
      getIt.registerLazySingleton<UsersRepository>(
        () => UsersRepository(pb: pb)
      );
      getIt.registerLazySingleton<GardensRepository>(
        () => GardensRepository(pb: pb)
      );
      getIt.registerLazySingleton<AppState>(
        () => AppState()
      );

      expect(getIt.isRegistered<PocketBase>(), true);
      expect(getIt.isRegistered<AppDialogViewRouter>(), true);
      expect(getIt.isRegistered<AsksRepository>(), true);
      expect(getIt.isRegistered<UserGardenRecordsRepository>(), true);
      expect(getIt.isRegistered<UserSettingsRepository>(), true);
      expect(getIt.isRegistered<UsersRepository>(), true);
      expect(getIt.isRegistered<GardensRepository>(), true);
      expect(getIt.isRegistered<AppState>(), true);

      await clearGetItInstance();

      expect(getIt.isRegistered<PocketBase>(), false);
      expect(getIt.isRegistered<AppDialogViewRouter>(), false);
      expect(getIt.isRegistered<AsksRepository>(), false);
      expect(getIt.isRegistered<UserGardenRecordsRepository>(), false);
      expect(getIt.isRegistered<UserSettingsRepository>(), false);
      expect(getIt.isRegistered<UsersRepository>(), false);
      expect(getIt.isRegistered<GardensRepository>(), false);
      expect(getIt.isRegistered<AppState>(), false);
    });
  });
}