import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

class RouteToListedAsksViewButton extends StatelessWidget {
  const RouteToListedAsksViewButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Tooltip(
      message: AskDialogTooltips.listedAsks,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
        ),
        onPressed: () => appDialogRouter.showAskDialogListView(),
        child: Icon(Icons.reorder)
      ),
    );
  }
}