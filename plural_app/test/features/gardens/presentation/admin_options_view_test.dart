import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';
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
      expect(find.byType(AppDialogCategoryHeader), findsNothing);
      expect(find.byType(AdminOptionsTile), findsNothing);
      expect(find.byType(AppDialogNavFooter), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminOptionsView), findsOneWidget);
      expect(find.byType(AppDialogCategoryHeader), findsOneWidget);
      expect(find.byType(AdminOptionsTile), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("AdminOptionsTile", (tester) async {
      final list = [1, 2, 3];
      void testFunc() => list.clear();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                AdminOptionsTile(
                  callback: testFunc,
                  icon: Icons.bakery_dining,
                  title: "TestAdminOptionsTileTitle"
                )
              ],
            ),
          ),
        )
      );

      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminOptionsTile), findsOneWidget);
      expect(find.text("TestAdminOptionsTileTitle"), findsOneWidget);
      expect(find.byIcon(Icons.bakery_dining), findsOneWidget);

      expect(list.isEmpty, false);

      await tester.tap(find.byType(AdminOptionsTile));
      await tester.pumpAndSettle();

      // Check callback was called (i.e. list is now empty)
      expect(list.isEmpty, true);
    });
  });
}