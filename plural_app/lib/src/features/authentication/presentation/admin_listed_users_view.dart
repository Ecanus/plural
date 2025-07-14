import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_user_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

Future createAdminListedUsersDialog(BuildContext context) async {
  final userGardenRecordsMap  = await getCurrentGardenUserGardenRecords(context);

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AdminListedUsersView(userGardenRecordsMap: userGardenRecordsMap)
        );
      }
    );
  }
}

class AdminListedUsersView extends StatelessWidget {
  const AdminListedUsersView({
    required this.userGardenRecordsMap,
  });

  final Map<AppUserGardenRole, List<AppUserGardenRecord>> userGardenRecordsMap;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    final sumUsers = userGardenRecordsMap.keys.fold<int>(
      0,
      (counter, key) => counter + userGardenRecordsMap[key]!.length
    );

    return Column(
      children: [
        gapH35,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_alt,
              color: Theme.of(context).colorScheme.onSecondary,
              size: AppIconSizes.s30,
            ),
            gapW15,
            Text(
              sumUsers.toString(),
              style: TextStyle(
                fontSize: AppFontSizes.s20,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p50),
            children: getTilesForListView(context, userGardenRecordsMap),
          ),
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.question_mark,
          leftNavCallback: () {},
          leftTooltipMessage: AppDialogFooterText.navToGardenDialog,
          rightDialogIcon: Icons.local_florist,
          rightNavCallback: appDialogViewRouter.routeToAdminCurrentGardenSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsDialog,
          title: AppDialogFooterText.adminListedUsers
        )
      ],
    );
  }
}

List<Widget> getTilesForListView(
  BuildContext context,
  Map<AppUserGardenRole, List<AppUserGardenRecord>> userGardenRecordsMap
) {

  List<AdminListedUserTile> tiles(List<AppUserGardenRecord> userGardenRecords) {
    return [
      for (AppUserGardenRecord record in userGardenRecords)
        AdminListedUserTile(userGardenRecord: record)
    ];
  }

  List<Widget> widgets = [];

  // Owner
  widgets += heading(context, AdminListedUsersViewText.ownerHeading);
  widgets += tiles(userGardenRecordsMap[AppUserGardenRole.owner]!);
  widgets += [gapH50];

  // Administrators
  final adminRecords = userGardenRecordsMap[AppUserGardenRole.administrator]!;
  widgets += heading(context, AdminListedUsersViewText.adminHeading);
  widgets += adminRecords.isEmpty ?
    emptyMessage(context, AdminListedUsersViewText.noAdministrators)
    : tiles(adminRecords);
  widgets += [gapH50];

  // Members
  final memberRecords = userGardenRecordsMap[AppUserGardenRole.member]!;
  widgets += heading(context, AdminListedUsersViewText.memberHeading);
  widgets += memberRecords.isEmpty ?
    emptyMessage(context, AdminListedUsersViewText.noMembers)
    : tiles(memberRecords);
  widgets += [gapH50];

  return widgets;
}

List<Widget> heading(BuildContext context, String label,) {
  return [
    Text(
      label,
      style: TextStyle(
        fontSize: AppFontSizes.s20
      )
    ),
    Divider(
      color: Theme.of(context).colorScheme.onSecondary,
      thickness: AppDividerThicknesses.dpt2,
    ),
    gapH10,
  ];
}

List<Widget> emptyMessage(BuildContext context, String message) {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
            fontSize: AppFontSizes.s14,
            fontStyle: FontStyle.italic
          ),
        ),
      ],
    ),
  ];
}