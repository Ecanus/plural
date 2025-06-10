import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart' as asks_api;
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart' as gardens_api;
import 'package:plural_app/src/features/gardens/domain/constants.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class AppState with ChangeNotifier {

  AppState();
  AppState.skipSubscribe() : _skipsSubscriptions = true;

  // primarily for testing
  bool _skipsSubscriptions = false;

  Garden? _currentGarden;

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

  /// Verifies the existence of a [UserGardenRecord] record associated with
  /// both the [currentUser] and the given [newGarden] before rerouting to the
  /// Garden page.
  ///
  /// If no corresponding [UserGardenRecord] is found, an error Snackbar will appear,
  /// and no reroute will take place.
  Future<void> setGardenAndReroute(BuildContext context, Garden newGarden) async {
    // TODO: check on a valid UserGardenRecord before redirecting
    // TODO: If fails, reload the page (i.e. reroute. Consider adding in the currentRoute as a parameter)
    // Check there exists a UserGardenRecord corresponding to _currentUser and newGarden
    final hasUserGardenRecord = true;

    // If exists corresponding UserGardenRecord, reroute
    if (hasUserGardenRecord && context.mounted) {
      currentGarden = newGarden; // will also call notifyListeners() and updateSubscriptions()
      GoRouter.of(context).go(Routes.garden);
    } else {
      // Else, show Snackbar error
      var snackBar = AppSnackbars.getSnackbar(
          SnackbarText.invalidGardenPermissions,
          duration: AppDurations.s9,
          snackbarType: SnackbarType.error
        );

        // Display error Snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Sets the value of [_currentGarden] to null without notifying listeners.
  ///
  /// Clears all database subscriptions as well.
  Future<void> clearGardenAndSubscriptions() async {
    _currentGarden = null;

    // Clear all database subscriptions
    final pb = GetIt.instance<PocketBase>();
    await pb.collection(Collection.asks).unsubscribe();
    await pb.collection(Collection.gardens).unsubscribe();
    await pb.collection(Collection.users).unsubscribe();
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

    // Users
    subscribeToUsers(
      newGarden.id,
      notifyAllListeners
    );
  }

  /// Returns the list of [Ask]s to be displayed in the [Garden] timeline.
  Future<List<Ask>> getTimelineAsks() async {
    var nowString = DateFormat(Formats.dateYMMddHms).format(DateTime.now());

    // Asks with target met, or deadlineDate passed are filtered out.
    var filterString = ""
      "&& ${AskField.targetMetDate} = null"
      "&& ${AskField.deadlineDate} > '$nowString'";

    List<Ask> asks = await asks_api.getAsksByGardenID(
      gardenID: currentGarden!.id,
      count: GardenConstants.numTimelineAsks,
      filter: filterString
    );

    _timelineAsksList = asks;

    return asks;
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  void refreshTimelineAsks() {
    _timelineAsksList.clear();
    notifyListeners();
  }
}
