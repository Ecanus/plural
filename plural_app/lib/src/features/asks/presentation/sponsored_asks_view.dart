import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/sponsored_ask_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class SponsoredAsksView extends StatelessWidget {
  const SponsoredAsksView({
    required this.sponsoredAskTiles,
  });

  final List<SponsoredAskTile> sponsoredAskTiles;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: sponsoredAskTiles,
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              icon: Icons.toc_rounded,
              message: AskViewText.goToListedAsks,
              callback: appDialogViewRouter.routeToListedAsksView,
            ),
            RouteToViewButton(
              icon: Icons.add,
              message: AskViewText.createAsk,
              callback: appDialogViewRouter.routeToCreateAskView
            ),
          ],
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: appDialogViewRouter.routeToCurrentGardenSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToCurrentGardenSettingsView,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogViewRouter.routeToUserSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsView,
          title: AppDialogFooterText.sponsoredAsks
        )
      ],
    );
  }
}