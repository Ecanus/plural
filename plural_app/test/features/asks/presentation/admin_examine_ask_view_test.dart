import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/admin_examine_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';
import 'package:plural_app/src/features/asks/presentation/delete_ask_button.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("AdminExamineAskView", () {
    testWidgets("widgets", (tester) async {
      final ask = AskFactory();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createAdminExamineAskDialog(
                    context: context, ask: ask),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check AdminExamineAskView not yet displayed
      expect(find.byType(AdminExamineAskView), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(AdminExamineAskView), findsOneWidget);
      expect(find.text(ask.description), findsOneWidget);
      expect(find.text("${ask.boon.toString()} ${ask.currency}"), findsOneWidget);
      expect(find.text(ask.instructions), findsOneWidget);
      expect(find.text(ask.creator.username), findsOneWidget);
      expect(find.byType(AppDialogFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("AdminExamineAskViewHeader", (tester) async {
      final ask = AskFactory();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminExamineAskViewHeader(ask: ask)
          ),
        )
      );

      expect(find.byType(DeleteAskButton), findsOneWidget);
      expect(find.byType(AskTimeLeftText), findsOneWidget);
    });

  });
}