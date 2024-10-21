import 'package:flutter/material.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/domain/utils.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import 'package:plural_app/src/features/authentication/domain/utils.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/viewable_user_dialog.dart';

class AppDialogManager {

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

  void showViewableUserDialogView(AppUser user) {
    dialogViewNotifier.value = UserDialogViewForm(user: user);
  }

  Future<void> showUserDialogListView() async {
    final listedUserTiles = await getListedUserTilesByUsers();
    dialogViewNotifier.value = UserDialogList(listedUserTiles: listedUserTiles);
  }

}