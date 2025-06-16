import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("AskDialogList test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings; // for initialValue of AppCurrencyPickerFormField

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.getAsksByUserID()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(
          filter: any(named: "filter")
        )
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createListedAsksDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check AskDialogList not yet displayed
      expect(find.byType(AskDialogList), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AskDialogList), findsOneWidget);
      expect(find.byType(ListedAskTile), findsNWidgets(3));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Check AskDialogCreateForm not yet in view
      expect(find.byType(AskDialogCreateForm), findsNothing);

      // Tap RouteToCreateAskViewButton (to route to another form view)
      await tester.ensureVisible(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();

      // Check RouteToCreateAskViewButton has been created
      expect(find.byType(AskDialogCreateForm), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("empty", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings; // for initialValue of AppCurrencyPickerFormField

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [])
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createListedAsksDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check widgets not yet displayed
      expect(find.byType(AskDialogList), findsNothing);
      expect(find.byType(EmptyListedAskTilesMessage), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AskDialogList), findsOneWidget);
      expect(find.byType(EmptyListedAskTilesMessage), findsOneWidget);
      expect(find.byType(ListedAskTile), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Check AskDialogCreateForm not yet in view
      expect(find.byType(AskDialogCreateForm), findsNothing);

      // Tap RouteToCreateAskViewButton (to route to another form view)
      await tester.ensureVisible(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToCreateAskViewButton));
      await tester.pumpAndSettle();

      // Check RouteToCreateAskViewButton has been created
      expect(find.byType(AskDialogCreateForm), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}