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
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createCurrentGardenSettingsDialog(BuildContext context) async {
  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: CurrentGardenSettingsView(),
        );
      }
    );
  }
}

class CurrentGardenSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.p35,
            right: AppPaddings.p35,
            top: AppPaddings.p50,
            bottom: AppPaddings.p10,
          ),
          child: Column(
            children: [
              GoToLandingPageTile(),
              GoToAdminPageTile(),
            ],
          )
        ),
        gapH10,
        Divider(
          color: Theme.of(context).colorScheme.onSecondary,
          indent: AppIndents.i200,
          endIndent: AppIndents.i200,
          thickness: AppDividerThicknesses.dpt2,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              RouteToExamineDoDocumentViewTile(
                callback: appDialogViewRouter.routeToExamineDoDocumentView,
              ),
              gapH30,
              ExitGardenButton(),
            ],
          ),
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.settings,
          leftNavCallback: appDialogViewRouter.routeToUserSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToSettingsView,
          rightDialogIcon: Icons.add,
          rightNavCallback: appDialogViewRouter.routeToCreateAskView,
          rightTooltipMessage: AppDialogFooterText.navToAsksView,
          title: AppDialogFooterText.garden
        )
      ],
    );
  }
}

class GoToLandingPageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          GardenSettingsViewText.goToLandingPageLabel,
          style: TextStyle(
            fontWeight: FontWeight.w500)
        ),
        leading: Icon(Icons.home),
        onTap: () {
          GoRouter.of(context).go(Routes.landing);
        }
      ),
    );
  }
}

class GoToAdminPageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: GetIt.instance<AppState>().isAdministrator(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return Card(
            elevation: AppElevations.e7,
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.secondaryFixed,
              title: Text(
                GardenSettingsViewText.goToAdminPageLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500)
              ),
              leading: Icon(Icons.security),
              onTap: () {
                GoRouter.of(context).go(Routes.admin);
              }
            ),
          );
        } else {
          return SizedBox();
        }
      }
    );
  }
}

class RouteToExamineDoDocumentViewTile extends StatelessWidget {
  const RouteToExamineDoDocumentViewTile({
    required this.callback
  });

  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          GardenSettingsViewText.routeToExamineDoDocumentView,
          style: TextStyle(
            fontWeight: FontWeight.w500)
        ),
        leading: Icon(Icons.auto_stories),
        onTap: () => callback()
      ),
    );
  }
}

class ExitGardenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: AppHeights.h50
      ),
      child: OutlinedButton(
        onPressed: () => showConfirmExitGardenDialog(context),
        style: ButtonStyle(
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: Theme.of(context).colorScheme.error
            )
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          ),
        ),
        child: Text(
          GardenSettingsViewText.exitGarden,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}

Future<void> showConfirmExitGardenDialog(
  BuildContext context,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmExitGardenDialog();
    }
  );
}

class ConfirmExitGardenDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p20,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c500,
          height: AppConstraints.c300,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  GardenSettingsViewText.confirmExitGarden,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    GardenSettingsViewText.confirmExitGardenSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            gapH50,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
                        )
                      ),
                    ),
                    child: Text(
                      GardenSettingsViewText.cancelConfirmExitGarden,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                    )
                  ),
                ),
                gapW15,
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: FilledButton(
                    onPressed: () {
                      rerouteToLandingPageWithExitedGardenID(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.error
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
                        )
                      ),
                    ),
                    child: const Text(GardenSettingsViewText.exitGarden)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}