import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

Future<void> submitCreate(
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final gardensRepository = GetIt.instance<GardensRepository>();
    final appDialogManager = GetIt.instance<AppDialogManager>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    await gardensRepository.create(map);

    // Return to Garden Dialog List View
    await appDialogManager.showGardenDialogListView();
  }
}

Future <void> submitUpdate(
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    final gardensRepository = GetIt.instance<GardensRepository>();
    final gardenStateManager = GetIt.instance<GardenManager>();
    final appDialogManager = GetIt.instance<AppDialogManager>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    var updatedGarden = await gardensRepository.update(map);

    // TODO: Remove all instances of timelineNotifier
    // Rebuild the Garden Timeline
    GetIt.instance<AppState>().currentGarden = updatedGarden;
    await gardenStateManager.timelineNotifier.updateValue(updatedGarden.id);

    // Rebuild Editable Garden Dialog
    appDialogManager.showEditableGardenDialogView(updatedGarden);
  }
}