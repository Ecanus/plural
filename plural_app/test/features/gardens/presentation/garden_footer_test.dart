import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("GardenFooter test", () {
    testWidgets("_isFooterCollapsed", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GardenFooter(),
          ),
        ));

      // Check AppBottomBar not rendered
      expect(find.byType(AppBottomBar), findsNothing);

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered
      expect(find.byType(AppBottomBar), findsOneWidget);
    });

    testWidgets("createListedAsksDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.getAsksByUserID()
      when(
        () => mockAsksRepository.getAsksByUserID(userID: tc.user.id)
      ).thenAnswer(
        (_) async => [tc.ask]
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(AskDialogList), findsNothing);

      // Tap IconButton with Icons.library_add (opens listed asks dialog)
      await tester.tap(find.byIcon(Icons.library_add));
      await tester.pumpAndSettle();

      expect(find.byType(AskDialogList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createUserSettingsDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; UserSettingsDialog not rendered
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(UserSettingsDialog), findsNothing);

      // Tap IconButton with Icons.settings (opens user settings dialog)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(UserSettingsDialog), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createListedUsersDialog", (tester) async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);

      // AuthRepository.getCurrentGardenUsers()
      when(
        () => mockAuthRepository.getCurrentGardenUsers()
      ).thenAnswer(
        (_) async => [tc.user, tc.user, tc.user, tc.user]
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(UserDialogList), findsNothing);

      // Tap IconButton with Icons.people_alt_rounded (opens listed users dialog)
      await tester.tap(find.byIcon(Icons.people_alt_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(UserDialogList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("createListedGardensDialog", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);

      // GardensRepository.getAsksByUserID()
      when(
        () => mockGardensRepository.getGardensByUser(any())
      ).thenAnswer(
        (_) async => [tc.garden, tc.garden]
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GardenFooter();
              }
            ),
          ),
        ));

      // Tap ElevatedButton (to toggle AppBottomBar)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check AppBottomBar is rendered; AskDialogList is not
      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(GardenDialogList), findsNothing);

      // Tap IconButton with Icons.local_florist (opens listed gardens dialog)
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      expect(find.byType(GardenDialogList), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}