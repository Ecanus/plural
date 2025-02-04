import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

class GardenTimelineNotifier extends ValueNotifier<List<Ask>> {
  GardenTimelineNotifier() : super([]);

  Future<void> updateValue(String gardenID) async {
    final asksRepository = GetIt.instance<AsksRepository>();

    var newValues = await asksRepository.getAsksByGardenID(
      gardenID: gardenID,
      count: GardenValues.numTimelineAsks);

    value = newValues;
  }
}