import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_gardens_tab.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("LandingPageGardensTab test", () {
    testWidgets("snapshot.hasData", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
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
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
          ]
        )
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageGardensTab()
          )
        ));

      // Check that only LandingPageGardensListLoading is rendered
      expect(find.byType(LandingPageGardensListLoading), findsOneWidget);
      expect(find.byType(LandingPageGardensList), findsNothing);
      expect(find.byType(LandingPageListedGardenTile), findsNothing);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that correct widgets are rendered next
      expect(find.byType(LandingPageGardensListLoading), findsNothing);
      expect(find.byType(LandingPageGardensList), findsOneWidget);
      expect(find.byType(LandingPageListedGardenTile), findsNWidgets(2));
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("empty", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
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
          items: []
        )
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageGardensTab()
          )
        ));

      // Check that only LandingPageGardensListLoading is rendered
      expect(find.byType(LandingPageGardensListLoading), findsOneWidget);
      expect(find.byType(LandingPageGardensList), findsNothing);
      expect(find.byType(LandingPageListedGardenTile), findsNothing);
      expect(find.byType(EmptyLandingPageGardensListMessage), findsNothing);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that correct widgets are rendered next
      expect(find.byType(LandingPageGardensListLoading), findsNothing);
      expect(find.byType(LandingPageGardensList), findsOneWidget);
      expect(find.byType(LandingPageListedGardenTile), findsNothing);
      expect(find.byType(EmptyLandingPageGardensListMessage), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("snapshot.hasError", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final pb = MockPocketBase();
      final gardensRepository = GardensRepository(pb: pb);
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => gardensRepository);

      // pb.collection()
      when(
        () => pb.collection(any())
      ).thenThrow(
        Exception("throw exception!")
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageGardensTab()
          )
        ));

      // Check that LandingPageGardensListLoading is rendered first
      expect(find.byType(LandingPageGardensListLoading), findsOneWidget);

      // Finish animations
      await tester.pumpAndSettle();

      // Check that LandingPageGardensListError is rendered next (due to exception)
      expect(find.byType(LandingPageGardensListError), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}