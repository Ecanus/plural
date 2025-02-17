import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Ask
import "package:plural_app/src/features/asks/data/asks_repository.dart";

// Utils
import 'package:plural_app/src/utils/app_form.dart';

Future<void> submitCreate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm
  ) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Update DB (should also rebuild Garden Timeline via SubscribeTo)
    var (isValid, errorsMap) =
      await GetIt.instance<AsksRepository>().create(appForm.fields);

    if (isValid && context.mounted) {
      // Display Success Snackbar
      var snackBar = AppSnackbars.getSuccessSnackbar(
        SnackBarMessages.createAskSuccess,
        duration: SnackBarDurations.s3,
        showCloseIcon: false
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Route to Listed Asks Dialog
      GetIt.instance<AppDialogRouter>().showAskDialogListView();
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild dialog
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

Future<void> submitUpdate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
  ) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Update DB (should also rebuild Garden Timeline via SubscribeTo)
    var (isValid, errorsMap) =
      await GetIt.instance<AsksRepository>().update(appForm.fields);

    if (isValid && context.mounted) {
      // Display Success Snackbar
      var snackBar = AppSnackbars.getSuccessSnackbar(
        SnackBarMessages.updateAskSuccess,
        duration: SnackBarDurations.s3,
        showCloseIcon: false
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Close Dialog
      Navigator.pop(context);
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild dialog
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

Future<void> submitDelete(
  BuildContext context,
  AppForm appForm,
) async {
  // Update DB (should also rebuild Garden Timeline via SubscribeTo)
  var (isValid, errorsMap) =
    await GetIt.instance<AsksRepository>().delete(appForm.fields);

  if (isValid && context.mounted) {
    // Display Success Snackbar
    var snackBar = AppSnackbars.getSuccessSnackbar(
      SnackBarMessages.deleteAskSuccess,
      duration: SnackBarDurations.s3,
      showCloseIcon: false
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Close Dialog
    Navigator.pop(context);
  }
}