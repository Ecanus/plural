import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/utils.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/presentation/creatable_garden_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/editable_garden_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/viewable_garden_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class AppDialogRouter {

  ValueNotifier<Widget> viewNotifier = ValueNotifier<Widget>(SizedBox());

  /// Asks
  void showCreatableAskDialogView() {
    viewNotifier.value = AskDialogCreateForm();
  }

  void showEditableAskDialogView(Ask ask) {
    viewNotifier.value = AskDialogEditForm(ask: ask);
  }

  Future<void> showAskDialogListView() async {
    final listedAskTiles = await getListedAskTilesByAsks();
    viewNotifier.value = AskDialogList(listedAskTiles: listedAskTiles);
  }

  /// Auth
  void showViewableUserDialogView(AppUser user) {
    viewNotifier.value = UserDialogViewForm(user: user);
  }

  Future<void> showUserDialogListView() async {
    final listedUserTiles = await getListedUserTilesByUsers();
    viewNotifier.value = UserDialogList(listedUserTiles: listedUserTiles);
  }

  Future<void> showUserSettingsDialogView() async {
    final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;
    viewNotifier.value = UserSettingsDialog(userSettings: currentUserSettings);
  }

  /// Gardens
  void showCreatableGardenDialogView() {
    viewNotifier.value = GardenDialogCreateForm();
  }

  Future<void> showGardenDialogListView() async {
    final listedGardenTiles = await getListedGardenTilesByUser();
    viewNotifier.value = GardenDialogList(listedGardenTiles: listedGardenTiles);
  }

  Future<void> showGardenSettingsDialogView() async {
    var appState = GetIt.instance<AppState>();
    var currentGarden = appState.currentGarden!;

    if (currentGarden.creator == appState.currentUser!) {
      showEditableGardenDialogView(currentGarden);
    } else {
      showViewableGardenDialogView(currentGarden);
    }
  }

  Future<void> showEditableGardenDialogView(Garden garden) async {
    viewNotifier.value = GardenDialogEditForm(garden: garden);
  }

  Future<void> showViewableGardenDialogView(Garden garden) async {
    viewNotifier.value = GardenDialogViewForm(garden: garden);
  }
}