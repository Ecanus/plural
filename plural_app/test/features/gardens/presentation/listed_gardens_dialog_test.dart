import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';


// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

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
        (_) async => [tc.garden, tc.garden, tc.garden]
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
        ));

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
  });
}