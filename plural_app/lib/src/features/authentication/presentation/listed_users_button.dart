import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Constants
import 'package:plural_app/src/constants/values.dart';
import 'package:plural_app/src/constants/strings.dart';

class ListedUsersButton extends StatelessWidget {
  const ListedUsersButton({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final stateManager = GetIt.instance<AppDialogManager>();

    return Ink(
      decoration: const ShapeDecoration(
        color: AppColors.darkGrey1,
        shape: CircleBorder()
      ),
      child: IconButton(
        icon: Icon(Icons.list),
        color: AppColors.secondaryColor,
        onPressed: () { stateManager.showUserDialogListView(); },
        tooltip: Strings.usersListButtonTooltip,
      ),
    );
  }
}