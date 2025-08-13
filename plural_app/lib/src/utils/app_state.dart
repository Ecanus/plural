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

  Garden? _currentGarden; // use Garden and not UserGardenRecord because caching the latter would prevent permission changes from being instantly applied

  AppUser? _currentUser;
  AppUserSettings? _currentUserSettings;

  List<Ask> _timelineAsksList = [];

  // _currentGarden
  Garden? get currentGarden => _currentGarden;
  set currentGarden(Garden? newGarden) {
    // Update subscriptions if newGarden is a new, non-null value
    if (!_skipsSubscriptions) {
      if (newGarden != null && newGarden != currentGarden) {
        updateSubscriptions(newGarden);
      }
    }

    _currentGarden = newGarden;
    notifyListeners();
  }

  // _currentUser
  AppUser? get currentUser => _currentUser;
  set currentUser(AppUser? newUser) {
    _currentUser = newUser;
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
  Future<void> clearGardenAndSubscriptions() async {
    _currentGarden = null;

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
        await verify([AppUserGardenPermission.viewAdminGardenTimeline]);
      } else {
        await verify([AppUserGardenPermission.viewGardenTimeline]);
      }

      final count = isAdminPage ? null : currentUserSettings!.gardenTimelineDisplayCount;
      final nowString = DateFormat(Formats.dateYMMddHHms).format(DateTime.now());

      // Asks with target met, or deadlineDate passed are filtered out.
      var filterString = ""
        "&& ${AskField.targetMetDate} = null"
        "&& ${AskField.deadlineDate} > '$nowString'"
        "&& ${AskField.creator} != '${currentUser!.id}'";

      // (in Garden page only) sponsored Asks are filtered out.
      if (!isAdminPage) filterString += "&& ${AskField.sponsors} !~ '${currentUser!.id}'";

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
  Future<void> setGardenAndReroute(
    BuildContext context,
    Garden newGarden, {
    GoRouter? goRouter, // primarily for testing
  }) async {
    final isMember = await currentUser!.hasRole(newGarden.id, AppUserGardenRole.member);

    if (context.mounted) {
      final router = goRouter ?? GoRouter.of(context);

      if (isMember) {
        currentGarden = newGarden; // will also call updateSubscriptions() and notifyListeners()
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
  /// the value of [_currentGarden]
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

  /// Checks if [currentUser]'s role in the [currentGarden]
  /// has correct matching [permissions].
  ///
  /// Throws a [PermissionException] if no match is found.
  Future<void> verify(List<AppUserGardenPermission> permissions) async {
    final userRole = await getUserGardenRecordRole(
      userID: currentUser!.id,
      gardenID: currentGarden!.id
    );

    if (userRole == null) throw PermissionException();

    final userPermissions = getUserGardenPermissionGroup(userRole);
    if (!userPermissions.toSet().containsAll(permissions)) throw PermissionException();
  }
}
