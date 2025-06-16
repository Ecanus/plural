import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/formats.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createListedAsksDialog(BuildContext context) async {
  final currentUserID = GetIt.instance<AppState>().currentUserID!;
  final nowString = DateFormat(Formats.dateYMMddHms).format(DateTime.now());

  final asks = await getAsksForListedAsksDialog(
    userID: currentUserID,
    nowString: nowString
  );

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AskDialogList(
            listedAskTiles: [for (var ask in asks) ListedAskTile(ask: ask)]
          ),
        );
      }
    );
  }
}

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
          leftNavCallback: appDialogRouter.routeToGardenDialogListView,
          leftTooltipMessage: AppDialogFooterText.navToGardens,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogRouter.routeToUserSettingsDialogView,
          rightTooltipMessage: AppDialogFooterText.navToSettings,
          title: AppDialogFooterText.asks
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