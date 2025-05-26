import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/routes.dart';

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
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.p40,
            right: AppPaddings.p40,
            top: AppPaddings.p50,
            bottom: AppPaddings.p10,
          ),
          child: ListedLandingPageTile(),
        ),
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

class ListedLandingPageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          GardenDialogText.listedLandingPageTileLabel,
          style: TextStyle(
            fontWeight: FontWeight.w500)
        ),
        leading: Icon(Icons.arrow_back_rounded),
        onTap: () {
          Navigator.pop(context);
          GoRouter.of(context).go(Routes.landing);
        }
      ),
    );
  }
}