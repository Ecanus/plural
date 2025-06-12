import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("GardenDialogList test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockUsersRepository = MockUsersRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
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
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
            tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden),
          ]
        )
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createListedGardensDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            ),
          ),
        )
      );

      // Check GardenDialogList not yet displayed
      expect(find.byType(GardenDialogList), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(GardenDialogList), findsOneWidget);
      expect(find.byType(ListedGardenTile), findsNWidgets(3));
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("ListedLandingPageTile", (tester) async {
      var testRouter = GoRouter(
        initialLocation: "/test_listed_landing_page_tile",
        routes: [
          GoRoute(
            path: Routes.landing,
            builder: (_, __) => SizedBox(
              child: Text("Test routing to Landing Page was successful."),
            )
          ),
          GoRoute(
            path: "/test_listed_landing_page_tile",
            builder: (_, __) => Scaffold(
            body: Builder(
                builder: (BuildContext context) {
                  return ListedLandingPageTile();
                }
              ),
            ),
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check routed text not rendered, widget is present, and tile label is rendered
      expect(find.text("Test routing to Landing Page was successful."), findsNothing);
      expect(find.text(GardenDialogText.listedLandingPageTileLabel), findsOneWidget);
      expect(find.byType(ListedLandingPageTile), findsOneWidget);

      // Tap on the ListTile
      await tester.tap(find.byType(ListedLandingPageTile));
      await tester.pumpAndSettle();

      // Check successful reroute (text should now appear)
      expect(find.text("Test routing to Landing Page was successful."), findsOneWidget);
    });
  });
}