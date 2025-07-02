import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

class RouteToListedAsksViewButton extends StatelessWidget {
  const RouteToListedAsksViewButton({
    this.icon = Icons.toc_rounded,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogViewRouter>();

    return Tooltip(
      message: AskDialogText.goToListedAsks,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
        ),
        onPressed: () => appDialogRouter.routeToListedAsksView(),
        child: Icon(icon)
      ),
    );
  }
}