import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/utils.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

Future createListedAsksDialog(BuildContext context) async {
  final listedAskTiles = await getListedAskTilesByAsks();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AskDialogList(listedAskTiles: listedAskTiles),
        );
      }
    );
  }
}

class AskDialogList extends StatelessWidget {
  const AskDialogList({
    super.key,
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
          leftNavCallback: appDialogRouter.showGardenDialogListView,
          leftTooltipMessage: AskDialogLabels.navToGardens,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogRouter.showUserSettingsDialogView,
          rightTooltipMessage: AskDialogLabels.navToSettings,
          title: AskDialogTitles.asks
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
      message: AskDialogLabels.createAsk,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.surface,
          shape: CircleBorder(),
        ),
        onPressed: () => appDialogRouter.showCreatableAskDialogView(),
        child: Icon(Icons.add)
      ),
    );
  }
}

