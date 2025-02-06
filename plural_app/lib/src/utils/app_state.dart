import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Constants
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class AppState with ChangeNotifier {

  Garden? _currentGarden;
  AppUser? _currentUser;
  AppUserGardenRecord? _currentUserLatestGardenRecord;

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

  // _currentUserLatestGardenRecord
  AppUserGardenRecord? get currentUserLatestGardenRecord {
    return _currentUserLatestGardenRecord;
  }
  set currentUserLatestGardenRecord(AppUserGardenRecord? newRecord) {
    _currentUserLatestGardenRecord = newRecord;
    notifyListeners();
  }

  String? get currentUserID {
    return _currentUser?.id;
  }

  Future<List<Ask>> getTimelineAsks() async {
    List<Ask> asks = await GetIt.instance<AsksRepository>().getAsksByGardenID(
      gardenID: currentGarden!.id,
      count: GardenValues.numTimelineAsks
    );

    return asks;
  }

  void notifyAllListeners() {
    notifyListeners();
  }
}
