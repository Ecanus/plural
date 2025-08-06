import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

// Tests
import '../test_mocks.dart';

void main() {
  group("RouteToViewButton", () {
    testWidgets("callbacks", (tester) async {
      final list = [1, 2, 3];
      void testAction(BuildContext context) => list.clear();

      final getIt = GetIt.instance;
      final mockAppDialogViewRouter = MockAppDialogViewRouter();
      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);

      // AppDialogViewRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogViewRouter.routeToListedAsksView()
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: RouteToViewButton(
              callback: mockAppDialogViewRouter.routeToListedAsksView,
              icon: Icons.abc,
              message: "test message!",
            )
          ),
        ));

      verifyNever(() => mockAppDialogViewRouter.routeToListedAsksView());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockAppDialogViewRouter.routeToListedAsksView()).called(1);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: RouteToViewButton(
              actionCallback: testAction,
              icon: Icons.abc,
              message: "test message!",
            )
          ),
        )
      );

      expect(list.isEmpty, false);

      // Tap button to call testAction
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(list.isEmpty, true);

    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("callback asserts", (tester) async {
      void testAction(BuildContext context) => "";
      void testCallback() => "";

      // AssertionError because both actionCallback and callback are provided
      expect(
        () async =>
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.standard,
            home: Scaffold(
              body: RouteToViewButton(
                actionCallback: testAction,
                callback: testCallback,
                icon: Icons.abc,
                message: "test message!",
              )
            ),
          )
        ),
        throwsA(predicate((e) => e is AssertionError))
      );
    });

    tearDown(() => GetIt.instance.reset());
  });
}