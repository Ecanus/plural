import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

Future<void> submitCreate(
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final gardensRepository = GetIt.instance<GardensRepository>();
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    // Save form
    formKey.currentState!.save();

    // Update DB
    await gardensRepository.create(map);

    // Return to Garden Dialog List View
    await appDialogRouter.showGardenDialogListView();
  }
}

Future <void> submitUpdate(
  GlobalKey<FormState> formKey,
  Map map,
) async {
  if (formKey.currentState!.validate()) {
    final gardensRepository = GetIt.instance<GardensRepository>();
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    // Save form
    formKey.currentState!.save();

    // Update DB (should also rebuild Garden Timeline via SubscribeTo)
    var updatedGarden = await gardensRepository.update(map);

    // Rebuild Editable Garden Dialog
    appDialogRouter.showEditableGardenDialogView(updatedGarden);
  }
}