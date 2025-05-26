import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/constants.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class AppState with ChangeNotifier {

  AppState();
  AppState.skipSubscribe() : skipSubscriptions = true;

  // only for testing
  bool skipSubscriptions = false;

  Garden? _currentGarden;

  AppUser? _currentUser;
  AppUserSettings? _currentUserSettings;

  List<Ask> _timelineAsks = [];

  // _currentGarden
  Garden? get currentGarden => _currentGarden;
  set currentGarden(Garden? newGarden) {
    // Update subscriptions if newGarden is a new, non-null value
    if (!skipSubscriptions) {
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

  String? get currentUserID {
    return _currentUser?.id;
  }

  // _timelineAsks
  List<Ask>? get timelineAsks {
    return _timelineAsks;
  }

  /// Resets the database subscriptions for all Collections affected by
  /// the value of currentGarden
  void updateSubscriptions(Garden newGarden) async {
    final pb = GetIt.instance<PocketBase>();

    // Clear all database subscriptions
    await pb.collection(Collection.asks).unsubscribe();
    await pb.collection(Collection.gardens).unsubscribe();
    await pb.collection(Collection.users).unsubscribe();

    // Set new database subscriptions
    GetIt.instance<AsksRepository>().subscribeTo(
      newGarden.id,
      notifyAllListeners
    );

    GetIt.instance<GardensRepository>().subscribeTo(
      newGarden.id
    );

    GetIt.instance<AuthRepository>().subscribeToUsers(
      newGarden.id,
      notifyAllListeners
    );
  }

  Future<List<Ask>> getTimelineAsks() async {
    var nowString = DateFormat(Formats.dateYMMddHms).format(DateTime.now());

    // Asks with target met, or deadlineDate passed are filtered out.
    var filterString = ""
    "&& ${AskField.targetMetDate} = null"
    "&& ${AskField.deadlineDate} > '$nowString'";

    List<Ask> asks = await GetIt.instance<AsksRepository>().getAsksByGardenID(
      gardenID: currentGarden!.id,
      count: GardenConstants.numTimelineAsks,
      filterString: filterString
    );

    _timelineAsks = asks;

    return asks;
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  void refreshTimelineAsks() {
    _timelineAsks.clear();
    notifyListeners();
  }
}
