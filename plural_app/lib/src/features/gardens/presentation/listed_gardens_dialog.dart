import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createListedGardensDialog(BuildContext context) async {
  final gardens = await GetIt.instance<GardensRepository>().getGardensByUser(
      GetIt.instance<AppState>().currentUserID!
    );

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: GardenDialogList(
            listedGardenTiles: [
              for (var garden in gardens) ListedGardenTile(garden: garden)
            ]
          ),
        );
      }
    );
  }
}

class GardenDialogList extends StatelessWidget {
  const GardenDialogList({
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
          leftNavCallback: appDialogRouter.routeToUserDialogListView,
          leftTooltipMessage: AppDialogFooterText.navToUsers,
          rightDialogIcon: Icons.aspect_ratio,
          rightNavCallback: appDialogRouter.routeToAskDialogListView,
          rightTooltipMessage: AppDialogFooterText.navToAsks,
          title: AppDialogFooterText.gardens
        )
      ],
    );
  }
}