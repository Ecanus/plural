import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

class ListedGardensButton extends StatelessWidget {
  const ListedGardensButton({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Ink(
      decoration: const ShapeDecoration(
        color: AppColors.darkGrey1,
        shape: CircleBorder()
      ),
      child: IconButton(
        icon: Icon(Icons.list),
        color: AppColors.secondaryColor,
        onPressed: () => appDialogRouter.showGardenDialogListView(),
        tooltip: Strings.gardensListButtonTooltip,
      ),
    );
  }
}