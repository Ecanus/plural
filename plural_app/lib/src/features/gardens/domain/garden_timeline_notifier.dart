import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

class GardenTimelineNotifier extends ValueNotifier<List<Ask>> {
  GardenTimelineNotifier() : super([]);

  updateValue() async {
    final getIt = GetIt.instance;
    final asksRepository = getIt<AsksRepository>();

    var newValues = await asksRepository.get();

    print(newValues);
    value = newValues;

    // value = [
    //     Ask(
    //       logCreationDate: DateTime(2024, 1, 1),
    //       uid: "00001",
    //       creatorUID: "PLURALTESTUSER1",
    //       description: "Need help with groceries this week. Anything helps!",
    //       deadlineDate: DateTime(2025, 2, 3),
    //     ),
    //     Ask(
    //       logCreationDate: DateTime(2024, 1, 4),
    //       uid: "00004",
    //       creatorUID: "TESTUSER2",
    //       description: "Architecture school isn't cheap :'(",
    //       deadlineDate: DateTime(2025, 4, 25),
    //     ),
    //     Ask(
    //       logCreationDate: DateTime(2024, 1, 7),
    //       uid: "00007",
    //       creatorUID: "TESTUSER3",
    //       description: "I'm going to the US Open, so help me God",
    //       deadlineDate: DateTime(2025, 7, 24),
    //     ),
    // ];
  }
}