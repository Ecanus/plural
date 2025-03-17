import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_gardens_tab.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_settings_tab.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("LandingPage test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);

      // GardensRepository.getGardensByUser()
      when(
        () => mockGardensRepository.getGardensByUser(any())
      ).thenAnswer(
        (_) async => [tc.garden]
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LandingPage(),
        ));

      // Check tabs are rendered
      final gardensTab = find.text(LandingPageText.gardens);
      final settingsTab = find.text(LandingPageText.settings);
      expect(gardensTab, findsOneWidget);
      expect(settingsTab, findsOneWidget);

      // Check only Gardens tab rendered fully; Settings tab not rendered
      expect(find.byType(LandingPageGardensTab), findsOneWidget);
      expect(find.byType(LandingPageSettingsTab), findsNothing);

      // Tap on Settings tab
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();

      // Check only Settings tab rendered fully; Gardens tab not rendered
      expect(find.byType(LandingPageGardensTab), findsNothing);
      expect(find.byType(LandingPageSettingsTab), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}