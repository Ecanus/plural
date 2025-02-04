import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Ask
import "package:plural_app/src/features/asks/data/asks_repository.dart";

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

Future<void> submitUpdate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final asksRepository = GetIt.instance<AsksRepository>();
    final gardenStateManager = GetIt.instance<GardenManager>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    await asksRepository.update(map);

    // TODO: Remove timelineNotifier, and use a subscribe on Asks collection to dynamically update timeline.
    // Rebuild the Garden Timeline
    await gardenStateManager.timelineNotifier.updateValue(
      GetIt.instance<AppState>().currentGarden!.id
    );

    // TODO: Wrap this method in a method that will either Close Dialog OR Reroute to Listed Asks Dialog
    // Close the Dialog
    if (context.mounted) Navigator.pop(context);
  }
}

Future<void> submitCreate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final asksRepository = GetIt.instance<AsksRepository>();
    final gardenStateManager = GetIt.instance<GardenManager>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    await asksRepository.create(map);

    // TODO: Remove timelineNotifier, and use a subscribe on Asks collection to dynamically update timeline.
    // Rebuild the Garden Timeline
    await gardenStateManager.timelineNotifier.updateValue(
      GetIt.instance<AppState>().currentGarden!.id
    );

    // TODO: Wrap this method in a method that will either Close Dialog OR Reroute to Listed Asks Dialog
    // Close the Dialog
    if (context.mounted) Navigator.pop(context);
  }
}