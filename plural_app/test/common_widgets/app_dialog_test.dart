import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

void main() {
  group("AppDialog test", () {
    testWidgets("AppDialogDismissable", (tester) async {
      final appDialogViewRouter = AppDialogViewRouter();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => appDialogViewRouter);

      appDialogViewRouter.setRouteTo(Text("AppDialogDismissable view value"));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogDismissable(
              appDialogViewRouter: appDialogViewRouter,
            ),
          ),
        ));

      // Check AppDialog view value is rendered
      expect(find.text("AppDialogDismissable view value"), findsOneWidget);
      expect(appDialogViewRouter.viewNotifier.value, isA<Text>());
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("AppDialogFullScreen", (tester) async {
      final appDialogViewRouter = AppDialogViewRouter();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => appDialogViewRouter);

      appDialogViewRouter.setRouteTo(Text("AppDialogFullScreen view value"));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogFullScreen(
              appDialogViewRouter: appDialogViewRouter,
            ),
          ),
        ));

      // Check AppDialog view value is rendered
      expect(find.text("AppDialogFullScreen view value"), findsOneWidget);
      expect(appDialogViewRouter.viewNotifier.value, isA<Text>());

      expect(find.byType(AppDialogFooterCloseFullScreenDialogButton), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}