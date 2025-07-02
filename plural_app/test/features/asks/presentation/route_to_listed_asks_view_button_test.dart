import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

// Tests
import '../../../test_mocks.dart';

void main() {
  group("RouteToListedAsksViewButton test", () {
    testWidgets("onPressed", (tester) async {
      final getIt = GetIt.instance;
      final mockAppDialogRouter = MockAppDialogRouter();
      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogRouter.routeToListedAsksView()
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: RouteToListedAsksViewButton()
          ),
        ));

      verifyNever(() => mockAppDialogRouter.routeToListedAsksView());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockAppDialogRouter.routeToListedAsksView()).called(1);
    });

    tearDown(() => GetIt.instance.reset());
  });
}