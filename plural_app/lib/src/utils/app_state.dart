import 'package:plural_app/src/features/asks/data/asks_api.dart' as asks_api;
import 'package:plural_app/src/features/gardens/data/gardens_api.dart' as gardens_api;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart' show PermissionException;

class AppState with ChangeNotifier {

  AppState();
  AppState.skipSubscribe() : _skipsSubscriptions = true;

  // primarily for testing
  bool _skipsSubscriptions = false;

  AppUser? _currentUser;
  AppUserGardenRecord? _currentUserGardenRecord;
  AppUserSettings? _currentUserSettings;

  List<Ask> _timelineAsksList = [];

  // currentGarden
  Garden? get currentGarden => _currentUserGardenRecord?.garden;

  // _currentUser
  AppUser? get currentUser => _currentUser;
  set currentUser(AppUser? newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  // _currentUserGardenRecord
  AppUserGardenRecord? get currentUserGardenRecord => _currentUserGardenRecord;
  set currentUserGardenRecord(AppUserGardenRecord? newUserGardenRecord) {
    // Update subscriptions if newUserGardenRecord is a new, non-null value
    if (!_skipsSubscriptions) {
      if (newUserGardenRecord != null && newUserGardenRecord != currentUserGardenRecord) {
        updateSubscriptions(newUserGardenRecord.garden);
      }
    }

    _currentUserGardenRecord = newUserGardenRecord;
    notifyListeners();
  }

  // _currentUserSettings
  AppUserSettings? get currentUserSettings => _currentUserSettings;
  set currentUserSettings(AppUserSettings? newUserSettings) {
    _currentUserSettings = newUserSettings;
    notifyListeners();
  }

  // _currentUser.id
  String? get currentUserID => _currentUser?.id;

  // _timelineAsks
  List<Ask>? get timelineAsks => _timelineAsksList;

  /// Sets the value of [_currentGarden] to null without notifying listeners.
  ///
  /// Clears all database subscriptions as well.
  Future<void> clearUserGardenRecordAndSubscriptions() async {
    _currentUserGardenRecord = null;

    // Clear all database subscriptions
    final pb = GetIt.instance<PocketBase>();
    await pb.collection(Collection.asks).unsubscribe();
    await pb.collection(Collection.gardens).unsubscribe();
    await pb.collection(Collection.userGardenRecords).unsubscribe();
    await pb.collection(Collection.users).unsubscribe();
  }

  /// An action. Returns the list of [Ask]s to be displayed in the [Garden], or Admin,
  /// timeline.
  Future<List<Ask>> getTimelineAsks(
    BuildContext context, {
    bool isAdminPage = false,
  }) async {
    try {
      if (isAdminPage) {
        verify([AppUserGardenPermission.viewAdminGardenTimeline]);
      } else {
        verify([AppUserGardenPermission.viewGardenTimeline]);
      }

      final count = isAdminPage ? null : currentUserSettings!.gardenTimelineDisplayCount;
      final nowString = DateFormat(Formats.dateYMMddHHms).format(DateTime.now());

      // Asks with target met, or deadlineDate passed are filtered out.
      var filterString = ""
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} > '$nowString'"
        "&& ${AskField.creator} != '${currentUserID!}'";

      // (in Garden page only) sponsored Asks are filtered out.
      if (!isAdminPage) filterString += "&& ${AskField.sponsors} !~ '${currentUserID!}'";

      List<Ask> asks = await asks_api.getAsksByGardenID(
        gardenID: currentGarden!.id,
        count: count,
        filter: filterString
      );

      _timelineAsksList = asks;

      return asks;
    } on PermissionException {
      // Redirect to UnauthorizedPage
      if (context.mounted) {
        final newRoute = isAdminPage ? Routes.garden : Routes.landing;

        GoRouter.of(context).go(
          Uri(
            path: Routes.unauthorized,
            queryParameters: { QueryParameters.previousRoute: newRoute }
          ).toString()
        );
      }

      return [];
    }
  }

  Future<bool> isAdministrator() async {
    return await currentUser!.hasRole(currentGarden!.id, AppUserGardenRole.administrator);
  }

  Future<bool> isOwner() async {
    return await currentUser!.hasRole(currentGarden!.id, AppUserGardenRole.owner);
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  void refreshTimelineAsks() {
    _timelineAsksList.clear();
    notifyListeners();
  }

  /// Verifies the existence of a [UserGardenRecord] record associated with
  /// both the [currentUser] and the given [newGarden] before rerouting to the
  /// Garden page.
  ///
  /// If no corresponding [UserGardenRecord] is found, an error Snackbar will appear,
  /// and the page will be refreshed.
  Future<void> setUserGardenRecordAndReroute(
    BuildContext context,
    Garden newGarden, {
    GoRouter? goRouter, // primarily for testing
  }) async {
    final newUserGardenRecord = await getUserGardenRecord(
      userID: currentUser!.id, gardenID: newGarden.id);

    if (context.mounted) {
      final router = goRouter ?? GoRouter.of(context);

      if (newUserGardenRecord != null) {
        currentUserGardenRecord = newUserGardenRecord; // will also call updateSubscriptions() and notifyListeners()
        router.go(Routes.garden);
      } else {
        // Redirect to UnauthorizedPage
        router.go(
          Uri(
            path: Routes.unauthorized,
            queryParameters: { QueryParameters.previousRoute: Routes.landing }
          ).toString()
        );
      }
    }
  }

  /// Resets the database subscriptions for all Collections dependant on
  /// the value of [newGarden]
  Future<void> updateSubscriptions(Garden newGarden) async {
    // Set new database subscriptions
    // Asks
    asks_api.subscribeTo(
      newGarden.id,
      notifyAllListeners
    );

    // Gardens
    gardens_api.subscribeTo(
      newGarden.id
    );

    // UserGardenRecords
    subscribeToUserGardenRecords(
      newGarden.id,
      notifyAllListeners
    );

    // Users
    subscribeToUsers(
      newGarden.id,
      notifyAllListeners
    );
  }

  /// Checks if [currentUserGardenRecord]'s role has correct matching [permissions].
  ///
  /// Throws a [PermissionException] if [currentUserGardenRecord] is null,
  /// or if no match is found.
  void verify(List<AppUserGardenPermission> permissions) async {
    if (currentUserGardenRecord == null) throw PermissionException();

    final userRole = currentUserGardenRecord!.role;
    final userPermissions = getUserGardenPermissionGroup(userRole);

    if (!userPermissions.toSet().containsAll(permissions)) throw PermissionException();
  }
}
