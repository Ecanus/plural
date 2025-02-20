import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class RouteToListedAsksViewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Tooltip(
      message: AskDialogText.listedAsks,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
        ),
        onPressed: () => appDialogRouter.routeToAskDialogListView(),
        child: const Icon(Icons.reorder)
      ),
    );
  }
}