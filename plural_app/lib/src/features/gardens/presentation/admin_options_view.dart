import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

Future createAdminOptionsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(view: AdminOptionsView());
    }
  );
}

class AdminOptionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Column(
                children: [
                  gapH50,
                  AppDialogCategoryHeader(
                    text: AdminOptionsViewText.invitationsHeader,
                  ),
                  gapH20,
                  AdminOptionsTile(
                    callback: appDialogViewRouter.routeToAdminCreateInvitationView,
                    icon: Icons.mail,
                    title: AdminOptionsViewText.createInvitationLabel,
                  )
                ],
              ),
            ]
          )
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: appDialogViewRouter.routeToAdminCurrentGardenSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToAdminCurrentGardenSettings,
          rightDialogIcon: Icons.people_alt,
          rightNavActionCallback: appDialogViewRouter.routeToAdminListedUsersView,
          rightTooltipMessage: AppDialogFooterText.navToAdminListedUsers,
          title: AppDialogFooterText.adminOptionsView
        ),
      ],
    );
  }
}

class AdminOptionsTile extends StatelessWidget {
  const AdminOptionsTile({
    required this.callback,
    required this.icon,
    required this.title,
  });

  final void Function() callback;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500
          ),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        onTap: () {
          Future.delayed(AppDurations.ms80, () {
            callback();
          });
        },
      ),
    );
  }
}