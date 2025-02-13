import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

// Ask
import "package:plural_app/src/features/asks/data/asks_repository.dart";

// Utils
import 'package:plural_app/src/utils/app_form.dart';

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
        SnackBarMessages.successfullyUpdatedAsk,
        duration: SnackBarDurations.s3,
        showCloseIcon: false
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Close Dialog
      Navigator.pop(context);
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap);

      appForm.getValue(fieldName: AppFormFields.rebuild)();
    }
  }
}

Future<void> submitCreate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final asksRepository = GetIt.instance<AsksRepository>();

    // Save form
    formKey.currentState!.save();

    // Update DB (should also rebuild Garden Timeline via SubscribeTo)
    await asksRepository.create(map);

    // TODO: Wrap this method in a method that will reroute to Listed Asks Dialog
    // Close the Dialog
    if (context.mounted) Navigator.pop(context);
  }
}