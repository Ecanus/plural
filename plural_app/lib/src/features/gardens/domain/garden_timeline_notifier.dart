import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

class GardenTimelineNotifier extends ValueNotifier<List<Ask>> {
  GardenTimelineNotifier() : super([]);

  updateValue() async {
    final getIt = GetIt.instance;
    final asksRepository = getIt<AsksRepository>();

    var newValues = await asksRepository.get(
      count: GardenValues.numTimelineAsks);

    value = newValues;
  }
}