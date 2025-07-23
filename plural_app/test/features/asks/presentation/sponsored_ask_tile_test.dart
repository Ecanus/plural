import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/sponsored_ask_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

// Localization
import '../../../test_context.dart';

void main() {
  group("SponsoredAskTile", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: ListView(
              children: [
                SponsoredAskTile(ask: tc.ask,),
              ],
            ),
          ),
        )
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text(tc.ask.listTileDescription), findsOneWidget);
      expect(find.text(tc.ask.timeRemainingString), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });
  });
}