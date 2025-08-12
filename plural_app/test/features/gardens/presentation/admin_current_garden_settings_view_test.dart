import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_hyperlinkable_text.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/admin_current_garden_settings_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

import '../../../test_context.dart';

void main() {
  group("AdminCurrentGardenSettingsView", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState.skipSubscribe()
                        ..currentGarden = tc.garden;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter()); // for AppDialogNavFooter

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createAdminCurrentGardenSettingsDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            ),
          ),
        )
      );

      // Check AdminCurrentGardenDialogList not yet displayed
      expect(find.byType(AdminCurrentGardenSettingsView), findsNothing);
      expect(find.byType(AppTextFormField), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsNothing);
      expect(find.byType(AppDialogNavFooter), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminCurrentGardenSettingsView), findsOneWidget);
      expect(find.byType(AppTextFormField), findsNWidgets(2));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    testWidgets("GoToCurrentGardenPageTile", (tester) async {
      final testRouter = GoRouter(
        initialLocation: "/test_listed_landing_page_tile",
        routes: [
          GoRoute(
            path: Routes.garden,
            builder: (_, __) => SizedBox(
              child: Text("Test routing to Garden Page was successful."),
            )
          ),
          GoRoute(
            path: "/test_listed_landing_page_tile",
            builder: (_, __) => Scaffold(
            body: Builder(
                builder: (BuildContext context) {
                  return GoToCurrentGardenPageTile();
                }
              ),
            ),
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check routed text not rendered, widget is present, and tile label is rendered
      expect(find.text("Test routing to Garden Page was successful."), findsNothing);
      expect(
        find.text(AdminCurrentGardenSettingsViewText.returnToGardenPage),
        findsOneWidget
      );
      expect(find.byType(GoToCurrentGardenPageTile), findsOneWidget);

      // Tap on the ListTile
      await tester.tap(find.byType(GoToCurrentGardenPageTile));
      await tester.pumpAndSettle();

      // Check successful reroute (text should now appear)
      expect(find.text("Test routing to Garden Page was successful."), findsOneWidget);
    });

    testWidgets("ShowAdminExamineDoDocumentDialogButton", (tester) async {
      final controller = TextEditingController();
      controller.text = "Testing the text displays!";

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ShowAdminExamineDoDocumentDialogButton(
                  textEditingController: controller,);
              }
            ),
          ),
        )
      );

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(AppHyperlinkableText), findsNothing);
      expect(find.text("Testing the text displays!"), findsNothing);

      // Tap ShowAdminExamineDoDocumentDialogButton (to open dialog)
      await tester.tap(find.byType(ShowAdminExamineDoDocumentDialogButton));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(AppHyperlinkableText), findsOneWidget);
      expect(find.text("Testing the text displays!"), findsOneWidget);

    });
  });
}