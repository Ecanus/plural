import 'package:flutter/material.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/utils.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

class AskDialogManager {

  Widget? view;
  ValueNotifier<Widget> dialogViewNotifier = ValueNotifier<Widget>(Container());

  void showCreatableAskDialogView() {
    dialogViewNotifier.value = AskDialogCreateForm();
  }

  void showEditableAskDialogView(Ask ask, {Widget? firstHeaderButton}) {
    dialogViewNotifier.value =
      AskDialogEditForm(
        ask: ask,
        firstHeaderButton: firstHeaderButton,
      );
  }

  Future<void> showAskDialogListView() async {
    final listedAskTiles = await getListedAskTilesByAsks();
    dialogViewNotifier.value = AskDialogList(listedAskTiles: listedAskTiles);
  }

}