import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/constants.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class AppState with ChangeNotifier {

  Garden? _currentGarden;

  AppUser? _currentUser;
  AppUserSettings? _currentUserSettings;

  List<Ask> _timelineAsks = [];

  // _currentGarden
  Garden? get currentGarden => _currentGarden;
  set currentGarden(Garden? newGarden) {
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

  Future<List<Ask>> getTimelineAsks() async {
    var nowString = DateFormat(Formats.dateYMMdd).format(DateTime.now());

    // Asks with target met, or deadlineDate passed are filtered out.
    var filterString = ""
    "${AskField.garden} = '${currentGarden!.id}'"
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
}
