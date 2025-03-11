import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';

void main() {
  group("AppDialog test", () {
    testWidgets("view", (tester) async {
      final appDialogRouter = AppDialogRouter();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogRouter>(() => appDialogRouter);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                AppDialog(
                  view: Text("AppDialog view value"),
                ),
              ],
            ),
          ),
        ));

      // Check AppDialog view value is rendered
      expect(find.text("AppDialog view value"), findsOneWidget);
      expect(appDialogRouter.viewNotifier.value, isA<Text>());
    });

    tearDown(() => GetIt.instance.reset());
  });
}