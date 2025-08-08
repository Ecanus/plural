import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';

/// Validates and submits form data to create a new [Invitation] record in the database.
Future<void> submitCreate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AppForm appForm,
) async {
  if (formKey.currentState!.validate()) {
    // Save form
    formKey.currentState!.save();

    // Update DB
    final (record, errorsMap) = await createInvitation(context, appForm.fields);

    if (record != null && context.mounted) {
      final snackBar = AppSnackBars.getSnackBar(
        SnackBarText.createInvitationSuccess,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Display Success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Route to Listed Asks View
      GetIt.instance<AppDialogViewRouter>().routeToAdminListedInvitationsView(context);
    } else {
      // Add errors to corresponding fields
      appForm.setErrors(errorsMap: errorsMap!);

      // Rebuild dialog
      appForm.getValue(
        fieldName: AppFormFields.rebuild,
        isAux: true)();
    }
  }
}