import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class ListedAsksView extends StatelessWidget {
  const ListedAsksView({
    required this.listedAskTiles,
  });

  final List<ListedAskTile> listedAskTiles;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        Expanded(
          child: listedAskTiles.isEmpty ?
            EmptyListedAskTilesMessage() :
            ListView(
              padding: const EdgeInsets.all(AppPaddings.p35),
              children: listedAskTiles,
            )
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              icon: Icons.volunteer_activism,
              message: AskViewText.goToSponsoredAsks,
              callback: appDialogViewRouter.routeToSponsoredAsksView,
            ),
            RouteToViewButton(
              icon: Icons.add,
              message: AskViewText.createAsk,
              callback: appDialogViewRouter.routeToCreateAskView
            )
          ],
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: appDialogViewRouter.routeToCurrentGardenSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToCurrentGardenSettingsView,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogViewRouter.routeToUserSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsView,
          title: AppDialogFooterText.listedAsks
        )
      ],
    );
  }
}

class EmptyListedAskTilesMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AskViewText.emptyListedAskTilesMessage,
            style: Theme.of(context).textTheme.headlineSmall
          ),
          gapH25,
          Text(
            AskViewText.emptyListedAskTilesSubtitle,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ],
      ),
    );
  }
}