import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/admin_options_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

void main() {
  group("AdminOptionsView", () {
    testWidgets("widgets", (tester) async {
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter()); // for AppDialogNavFooter

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createAdminOptionsDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            ),
          ),
        )
      );

      // Check AdminOptionsView not yet displayed
      expect(find.byType(AdminOptionsView), findsNothing);
      expect(find.byType(AppDialogNavFooter), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminOptionsView), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

    });
  });
}