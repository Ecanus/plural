import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_user_tile.dart';

Future createListedUsersDialog(BuildContext context) async {
  final users = await GetIt.instance<AuthRepository>().getCurrentGardenUsers();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: UserDialogList(
            listedUserTiles: [for (var user in users) ListedUserTile(user: user)]
          ),
        );
      }
    );
  }
}

class UserDialogList extends StatelessWidget {
  const UserDialogList({
    required this.listedUserTiles,
  });

  final List<ListedUserTile> listedUserTiles;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Column(
      children: [
        ListedUsersHeader(count: listedUserTiles.length),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: listedUserTiles,
          ),
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.settings,
          leftNavCallback: appDialogRouter.routeToUserSettingsDialogView,
          leftTooltipMessage: AppDialogTooltips.navToSettings,
          rightDialogIcon: Icons.local_florist,
          rightNavCallback: appDialogRouter.routeToGardenDialogListView,
          rightTooltipMessage: AppDialogTooltips.navToGardens,
          title: AppDialogTitles.users
        )
      ],
    );
  }
}

class ListedUsersHeader extends StatelessWidget {
  const ListedUsersHeader({
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPaddings.p35,
        top: AppPaddings.p35,
        right: AppPaddings.p35,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_rounded,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: AppIconSizes.s35
          ),
          gapW10,
          Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}