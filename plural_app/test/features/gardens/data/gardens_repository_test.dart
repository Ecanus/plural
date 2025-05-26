import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Gardens repository test", () {
    test("getGardenByID", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final gardensRepository = GardensRepository(pb: pb);

      final recordService = MockRecordService();

      // GetIt
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(pb: pb)
      );

      // pb.collection()
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

      var garden = await gardensRepository.getGardenByID(tc.garden.id);
      expect(garden.id, tc.garden.id);
      expect(garden.creator, tc.garden.creator);
      expect(garden.name, tc.garden.name);
    });

    tearDown(() => GetIt.instance.reset());

    test("getGardensByUser", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final getIt = GetIt.instance;

      final gardensRepository = GardensRepository(pb: pb);
      final recordService = MockRecordService();

      // GetIt
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(pb: pb)
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.userGardenRecords)
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
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          expand: UserGardenRecordField.garden,
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: any(named: "sort"))
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getGardenRecordRecordModelFromJson(UserGardenRecordField.garden)])
      );

      var gardens = await gardensRepository.getGardensByUser(tc.user.id);
      expect(gardens.length, 1);

      var garden = gardens.first;
      expect(garden, isA<Garden>());
      expect(garden.id, tc.garden.id);
      expect(garden.creator, tc.user);
      expect(garden.name, tc.garden.name);
    });

    tearDown(() => GetIt.instance.reset());
  });
}