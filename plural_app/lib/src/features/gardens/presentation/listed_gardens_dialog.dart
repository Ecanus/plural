import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/utils.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

Future createListedGardensDialog(BuildContext context) async {
  final listedGardenTiles = await getListedGardenTilesByUser();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: GardenDialogList(listedGardenTiles: listedGardenTiles),
        );
      }
    );
  }
}

class GardenDialogList extends StatelessWidget {
  const GardenDialogList({
    super.key,
    required this.listedGardenTiles,
  });

  final List<ListedGardenTile> listedGardenTiles;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: listedGardenTiles,
          ),
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.people_alt_rounded,
          leftNavCallback: appDialogRouter.showUserDialogListView,
          leftTooltipMessage: AppDialogTooltips.navToUsers,
          rightDialogIcon: Icons.library_add,
          rightNavCallback: appDialogRouter.showAskDialogListView,
          rightTooltipMessage: AppDialogTooltips.navToAsks,
          title: AppDialogTitles.gardens
        )
      ],
    );
  }
}