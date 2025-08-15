import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/sponsored_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/sponsored_asks_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("SponsoredAsksView", () {
    testWidgets("widgets", (tester) async {
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: SponsoredAsksView(sponsoredAskTiles: [
                SponsoredAskTile(ask: AskFactory()),
                SponsoredAskTile(ask: AskFactory()),
                SponsoredAskTile(ask: AskFactory()),
              ])
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.byType(SponsoredAsksView), findsOneWidget);
      expect(find.byType(SponsoredAskTile), findsNWidgets(3));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      expect(find.byType(RouteToViewButton), findsNWidgets(2));
    });

    tearDown(() => GetIt.instance.reset());
  });
}