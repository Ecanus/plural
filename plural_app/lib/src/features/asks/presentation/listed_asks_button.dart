import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

class ListedAsksButton extends StatelessWidget {
  const ListedAsksButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: CircleBorder()
      ),
      child: IconButton(
        icon: Icon(Icons.list),
        color: AppColors.secondaryColor,
        onPressed: () { appDialogRouter.showAskDialogListView(); },
        tooltip: Strings.asksListButtonTooltip,
      ),
    );
  }
}