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
import 'package:plural_app/src/utils/app_dialog_router.dart';

class AskDialogList extends StatelessWidget {
  const AskDialogList({
    required this.listedAskTiles,
  });

  final List<ListedAskTile> listedAskTiles;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

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
        AppDialogFooterBuffer(buttons: [RouteToCreateAskViewButton()],),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: appDialogRouter.routeToCurrentGardenDialogView,
          leftTooltipMessage: AppDialogFooterText.navToGardenDialog,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogRouter.routeToUserSettingsDialogView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsDialog,
          title: AppDialogFooterText.listedAsks
        )
      ],
    );
  }
}

class RouteToCreateAskViewButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Tooltip(
      message: AskDialogText.createAsk,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.surface,
          shape: CircleBorder(),
        ),
        onPressed: () => appDialogRouter.routeToCreatableAskDialogView(),
        child: const Icon(Icons.add)
      ),
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
            AskDialogText.emptyListedAskTilesMessage,
            style: Theme.of(context).textTheme.headlineSmall
          ),
          gapH25,
          Text(
            AskDialogText.emptyListedAskTilesSubtitle,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ],
      ),
    );
  }
}