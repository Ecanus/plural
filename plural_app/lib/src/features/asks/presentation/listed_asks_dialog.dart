import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

Future createListedAsksDialog(BuildContext context) async {
  final currentUserID = GetIt.instance<AppState>().currentUserID!;
  final asks = await GetIt.instance<AsksRepository>().getAsksByUserID(
    userID: currentUserID);

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
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: listedAskTiles,
          ),
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

