import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/creatable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_dialog.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_user_tile.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_gardens_dialog.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class AppDialogRouter {
  ValueNotifier<Widget> _viewNotifier = ValueNotifier<Widget>(SizedBox());

  ValueNotifier<Widget> get viewNotifier {
    return _viewNotifier;
  }

  void setRouteTo(Widget widget) {
    _viewNotifier.value = widget;
  }

  /// Asks
  void routeToCreatableAskDialogView() {
    _viewNotifier.value = AskDialogCreateForm();
  }

  void routeToEditableAskDialogView(Ask ask) {
    _viewNotifier.value = AskDialogEditForm(ask: ask);
  }

  Future<void> routeToAskDialogListView() async {
    final currentUserID = GetIt.instance<AppState>().currentUserID!;
    final asks = await GetIt.instance<AsksRepository>().getAsksByUserID(
      userID: currentUserID);

    _viewNotifier.value = AskDialogList(
      listedAskTiles: [for (Ask ask in asks) ListedAskTile(ask: ask)]
    );
  }

  /// Auth
  Future<void> routeToUserDialogListView() async {
    final users = await GetIt.instance<AuthRepository>().getCurrentGardenUsers();

    _viewNotifier.value = UserDialogList(
      listedUserTiles: [for (var user in users) ListedUserTile(user: user)]
    );
  }

  Future<void> routeToUserSettingsDialogView() async {
    final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;
    _viewNotifier.value = UserSettingsDialog(userSettings: currentUserSettings);
  }

  /// Gardens
  Future<void> routeToGardenDialogListView() async {
    final gardens = await GetIt.instance<GardensRepository>().getGardensByUser(
      GetIt.instance<AppState>().currentUserID!
    );

    _viewNotifier.value = GardenDialogList(
      listedGardenTiles: [for (var garden in gardens) ListedGardenTile(garden: garden)]
    );
  }
}