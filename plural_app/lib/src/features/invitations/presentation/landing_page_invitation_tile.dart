import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/themes.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class LandingPageInvitationTile extends StatelessWidget {
  const LandingPageInvitationTile({
    required this.invitation,
    required this.setStateCallback,
  });

  final Invitation invitation;
  final void Function() setStateCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          invitation.garden.name,
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(
          ""
          "${LandingPageText.expires} "
          "${DateFormat(Formats.dateYMMdd).format(invitation.expiryDate)}",
          style: TextStyle(
            fontStyle: FontStyle.italic
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: LandingPageText.acceptInvitation,
              onPressed: () => acceptInvitationAndCreateUserGardenRecord(
                invitation,
                callback: () {
                  final snackBar = AppSnackBars.getSnackBar(
                    SnackBarText.acceptedInvitation,
                    duration: AppDurations.s9,
                    showCloseIcon: true,
                    snackbarType: SnackbarType.success
                  );

                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setStateCallback();
                }
              ),
              icon: Icon(
                Icons.check,
                color: AppThemes.positiveColor
              ),
            ),
            IconButton(
              tooltip: LandingPageText.declineInvitation,
              onPressed: () => deleteInvitation(
                invitation.id,
                callback: () {
                  final snackBar = AppSnackBars.getSnackBar(
                    SnackBarText.declinedInvitation,
                    duration: AppDurations.s9,
                    showCloseIcon: true,
                    snackbarType: SnackbarType.success
                  );

                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setStateCallback();
                }
              ),
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.error,
              ),
            )
          ],
        ),
      )
    );
  }
}