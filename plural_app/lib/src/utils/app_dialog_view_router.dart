import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/formats.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/edit_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_edit_user_view.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_users_view.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_view.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class AppDialogViewRouter {
  final ValueNotifier<Widget> viewNotifier = ValueNotifier<Widget>(SizedBox());

  void setRouteTo(Widget widget) {
    viewNotifier.value = widget;
  }

  /// Asks
  void routeToCreateAskView() {
    viewNotifier.value = CreateAskView();
  }

  void routeToEditAskView(Ask ask) {
    viewNotifier.value = EditAskView(ask: ask);
  }

  Future<void> routeToListedAsksView() async {
    final currentUserID = GetIt.instance<AppState>().currentUserID!;

    final datetimeNow = DateTime.parse(
        DateFormat(Formats.dateYMMddHHms).format(DateTime.now())).toLocal();

    final asks = await getAsksForListedAsksDialog(
      userID: currentUserID,
      now: datetimeNow,
    );

    viewNotifier.value = ListedAsksView(
      listedAskTiles: [for (Ask ask in asks) ListedAskTile(ask: ask)]
    );
  }

  /// Auth
  void routeToAdminEditUserView(AppUserGardenRecord userGardenRecord) {
    viewNotifier.value = AdminEditUserView(userGardenRecord: userGardenRecord);
  }

  Future<void> routeToAdminListedUsersView(BuildContext context) async {
    final userGardenRecordsMap = await getCurrentGardenUserGardenRecords(context);

    viewNotifier.value = AdminListedUsersView(userGardenRecordsMap: userGardenRecordsMap);
  }

  Future<void> routeToUserSettingsView() async {
    final currentUser = GetIt.instance<AppState>().currentUser!;
    final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;

    viewNotifier.value = UserSettingsView(
      user: currentUser, userSettings: currentUserSettings
    );
  }

  /// Gardens
  void routeToCurrentGardenSettingsView() {
    viewNotifier.value = CurrentGardenSettingsView();
  }
}