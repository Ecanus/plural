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
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';
import 'package:plural_app/src/features/authentication/domain/utils.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/viewable_user_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/utils.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/presentation/creatable_garden_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/editable_garden_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/viewable_garden_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

class AppDialogManager {

  Widget? view;
  ValueNotifier<Widget> dialogViewNotifier = ValueNotifier<Widget>(Container());

  /// Asks
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

  /// Auth
  void showViewableUserDialogView(AppUser user) {
    dialogViewNotifier.value = UserDialogViewForm(user: user);
  }

  Future<void> showUserDialogListView() async {
    final listedUserTiles = await getListedUserTilesByUsers();
    dialogViewNotifier.value = UserDialogList(listedUserTiles: listedUserTiles);
  }

  Future<void> showUserSettingsDialogView({AppUserSettings? userSettings}) async {
    userSettings = userSettings ??
      await GetIt.instance<AuthRepository>().getCurrentUserSettings();

    dialogViewNotifier.value = UserSettingsDialog(userSettings: userSettings);
  }

  /// Gardens
  void showCreatableGardenDialogView() {
    dialogViewNotifier.value = GardenDialogCreateForm();
  }

  Future<void> showGardenDialogListView() async {
    final listedGardenTiles = await getListedGardenTilesByUser();
    dialogViewNotifier.value = GardenDialogList(listedGardenTiles: listedGardenTiles);
  }

  Future<void> showGardenSettingsDialogView() async {
    var currentGarden = GetIt.instance<GardenManager>().currentGarden;
    var currentUser = GetIt.instance<AuthRepository>().currentUser!;

    if (currentGarden!.creator == currentUser) {
      showEditableGardenDialogView(currentGarden);
    } else {
      showViewableGardenDialogView(currentGarden);
    }
  }

  Future<void> showEditableGardenDialogView(Garden garden) async {
    dialogViewNotifier.value = GardenDialogEditForm(garden: garden);
  }

  Future<void> showViewableGardenDialogView(Garden garden) async {
    dialogViewNotifier.value = GardenDialogViewForm(garden: garden);
  }
}