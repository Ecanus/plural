import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/gardens/presentation/app_bottom_bar.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("GardenFooter test", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory(creator: user);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

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

      // Check AppBottomBar is rendered; check MouseRegion is rendered
      expect(find.byType(AppBottomBar), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}