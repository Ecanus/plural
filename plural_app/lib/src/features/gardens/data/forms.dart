import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

/// Validates and submits form data to update an existing [Garden] record in the database.
Future<void> submitUpdate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    SnackBar snackBar;

    // Save form
    formKey.currentState!.save();

    // Update DB (should also rebuild Garden Timeline via SubscribeTo)
    final (record, errorsMap) = await updateGardenName(context, appForm.fields);

    if (record != null && context.mounted) {
      snackBar = AppSnackBars.getSnackBar(
        SnackBarText.updateGardenNameSuccess,
        snackbarType: SnackbarType.success
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (errorsMap != null) {
      appForm.setErrors(errorsMap: errorsMap);
      appForm.getValue(fieldName: AppFormFields.rebuild, isAux: true)();
      return;
    }
  }
}