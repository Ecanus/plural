import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/service_locator.dart';

// Tests
import '../test_context.dart';
import '../test_mocks.dart';

// For AuthStore()
class MockModel {
  String id;

  MockModel(this.id);

  void clear() {}

  Map<String, dynamic> toJson() {
    return {
      GenericField.id: id,
    };
  }
}

void main() {
  group("Service locator test", () {
    test("registerGetItInstances", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;
      final recordService = MockRecordService();

      // pb.authStore.model
      final authStore = AuthStore();
      authStore.save("newToken", MockModel(tc.user.id));
      when(
        () => pb.authStore.model
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
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      await registerGetItInstances(pb);

      expect(getIt.isRegistered<PocketBase>(), true);
      expect(getIt.isRegistered<AppDialogRouter>(), true);
      expect(getIt.isRegistered<AsksRepository>(), true);
      expect(getIt.isRegistered<AuthRepository>(), true);
      expect(getIt.isRegistered<GardensRepository>(), true);

      expect(getIt.isRegistered<AppState>(), true);
      expect(getIt<AppState>().currentUser, tc.user);
      expect(getIt<AppState>().currentUserSettings, tc.userSettings);
    });

    tearDown(() => GetIt.instance.reset());

    test("clearGetItInstances", () async {
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      // GetIt
      getIt.registerLazySingleton<PocketBase>(
        () => pb
      );

      // pb.authStore.model
      final authStore = AuthStore();
      when(
        () => pb.authStore
      ).thenReturn(
        authStore
      );

      // test logout == false
      expect(getIt.isRegistered<PocketBase>(), true);
      await clearGetItInstances(logout: false);
      expect(getIt.isRegistered<PocketBase>(), false);

      // test logout == true
      getIt.registerLazySingleton<PocketBase>(
        () => pb
      );

      expect(getIt.isRegistered<PocketBase>(), true);
      await clearGetItInstances(logout: true);
      expect(getIt.isRegistered<PocketBase>(), false);
      verify(() => pb.authStore.clear()).called(1);
    });
  });
}