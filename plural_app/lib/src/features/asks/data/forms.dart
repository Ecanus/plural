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
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
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
    final (record, errorsMap) = await GetIt.instance<AsksRepository>().create(
      body: appForm.fields
    );

    if (record != null && context.mounted) {
      final snackBar = AppSnackBars.getSnackBar(
        SnackBarText.createAskSuccess,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Route to Listed Asks View
      GetIt.instance<AppDialogViewRouter>().routeToListedAsksView();
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      // Rebuild dialog
      appForm.getValue(
        fieldName: AppFormFields.rebuild,
        isAux: true)();
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
    final (record, errorsMap) = await GetIt.instance<AsksRepository>().update(
        id: appForm.getValue(fieldName: GenericField.id),
        body: appForm.fields
      );

    if (record != null && context.mounted) {
      final snackBar = AppSnackBars.getSnackBar(
        SnackBarText.updateAskSuccess,
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
      appForm.getValue(
        fieldName: AppFormFields.rebuild,
        isAux: true)();
    }
  }
}