import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Ask
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_form.dart';


/// Validates and submits form data to create a new [Ask] record in the database.
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
      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.createAskSuccess,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Route to Listed Asks Dialog
      GetIt.instance<AppDialogRouter>().routeToAskDialogListView();
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild dialog
      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

/// Validates and submits form data to update an existing [Ask] record in the database.
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
      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.updateAskSuccess,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Display Success Snackbar
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

/// Submits form data to delete an existing [Ask] record in the database.
Future<void> submitDelete(
  BuildContext context,
  AppForm appForm,
) async {
  // Update DB (should also rebuild Garden Timeline via SubscribeTo)
  var (isValid, errorsMap) =
    await GetIt.instance<AsksRepository>().delete(appForm.fields);

  if (isValid && context.mounted) {
    var snackBar = AppSnackbars.getSnackbar(
      SnackbarText.deleteAskSuccess,
      showCloseIcon: false,
      snackbarType: SnackbarType.success
    );

    // Display Success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Close Dialog
    Navigator.pop(context);
  }
}