import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask_dialog_manager.dart';

class ListedAsksButton extends StatelessWidget {
  const ListedAsksButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final stateManager = GetIt.instance<AskDialogManager>();

    return Ink(
      decoration: const ShapeDecoration(
        color: AppColors.darkGrey1,
        shape: CircleBorder()
      ),
      child: IconButton(
        onPressed: () { stateManager.showAskDialogListView(); },
        icon: Icon(Icons.list),
        color: AppColors.secondaryColor,
      ),
    );
  }
}