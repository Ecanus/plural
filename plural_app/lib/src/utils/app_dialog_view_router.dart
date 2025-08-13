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
import 'package:plural_app/src/features/asks/presentation/examine_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_asks_view.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/sponsored_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/sponsored_asks_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_edit_user_view.dart';
import 'package:plural_app/src/features/authentication/presentation/admin_listed_users_view.dart';
import 'package:plural_app/src/features/authentication/presentation/user_settings_view.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/admin_current_garden_settings_view.dart';
import 'package:plural_app/src/features/gardens/presentation/admin_options_view.dart';
import 'package:plural_app/src/features/gardens/presentation/current_garden_settings_view.dart';
import 'package:plural_app/src/features/gardens/presentation/examine_do_document_view.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_create_invitation_view.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitations_view.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class AppDialogViewRouter {
  final ValueNotifier<Widget> viewNotifier = ValueNotifier<Widget>(SizedBox());

  void setRouteTo(Widget widget) {
    viewNotifier.value = widget;
  }

  // Asks
  Future<void> routeToCreateAskView() async {
    final userGardenRecord = await getUserGardenRecord(
      userID: GetIt.instance<AppState>().currentUser!.id,
      gardenID: GetIt.instance<AppState>().currentGarden!.id,
    );

    viewNotifier.value = CreateAskView(
      hasReadDoDocument: userGardenRecord!.hasReadDoDocument,
    );
  }

  void routeToEditAskView(Ask ask) {
    viewNotifier.value = EditAskView(ask: ask);
  }

  Future<void> routeToExamineAskView(Ask ask) async {
    viewNotifier.value = ExamineAskView(
      ask: ask,
      routeToIcon: Icons.arrow_back,
    );
  }

  Future<void> routeToListedAsksView() async {
    final datetimeNow = DateTime.parse(
      DateFormat(Formats.dateYMMddHHms).format(DateTime.now())).toLocal();

    final asks = await getAsksForListedAsksView(
      userID: GetIt.instance<AppState>().currentUserID!,
      now: datetimeNow,
    );

    viewNotifier.value = ListedAsksView(
      listedAskTiles: [for (Ask ask in asks) ListedAskTile(ask: ask)]
    );
  }

  Future<void> routeToSponsoredAsksView() async {
    final datetimeNow = DateTime.parse(
      DateFormat(Formats.dateYMMddHHms).format(DateTime.now())).toLocal();

    final asks = await getAsksForSponsoredAsksView(now: datetimeNow);

    viewNotifier.value = SponsoredAsksView(
      sponsoredAskTiles: [for (Ask ask in asks) SponsoredAskTile(ask: ask)]
    );
  }

  // Auth
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

  // Gardens
  void routeToAdminCurrentGardenSettingsView() {
    viewNotifier.value = AdminCurrentGardenSettingsView();
  }

  void routeToAdminOptionsView() {
    viewNotifier.value = AdminOptionsView();
  }

  void routeToCurrentGardenSettingsView() {
    viewNotifier.value = CurrentGardenSettingsView();
  }

  Future<void> routeToExamineDoDocumentView() async {
    final userGardenRecord = await getUserGardenRecord(
      userID: GetIt.instance<AppState>().currentUser!.id,
      gardenID: GetIt.instance<AppState>().currentGarden!.id,
    );

    viewNotifier.value = ExamineDoDocumentView(userGardenRecord: userGardenRecord!);
  }

  // Invitations
  void routeToAdminCreateInvitationView() {
    viewNotifier.value = AdminCreateInvitationView();
  }

  Future<void> routeToAdminListedInvitationsView(BuildContext context) async {
    final invitationsMap = await getCurrentGardenInvitations(context);

    viewNotifier.value = AdminListedInvitationsView(invitationsMap: invitationsMap,);
  }
}