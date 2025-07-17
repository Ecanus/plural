import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Feature not yet implemented",
                  style: Theme.of(context).textTheme.headlineSmall
                ),
                gapH25,
              ]
            )
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