import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/formats.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/utils_api.dart';

class AdminListedInvitationTile extends StatelessWidget {
  const AdminListedInvitationTile({
    required this.invitation,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          invitation.uuid ?? invitation.invitee?.username
          ?? AdminInvitationViewText.invalidInvitation,
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(
          ""
          "${AdminInvitationViewText.expires} "
          "${DateFormat(Formats.dateYMMdd).format(invitation.expiryDate)}",
          style: TextStyle(
            fontStyle: FontStyle.italic
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            invitation.uuid != null ?
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () => copyToClipboard(context, invitation.uuid!),
                tooltip: AdminInvitationViewText.copyCode,
              ) : SizedBox(),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => showConfirmExpireInvitationDialog(context, invitation.id),
              tooltip: AdminInvitationViewText.deleteInvitation,
            ),
          ],
        ),
      )
    );
  }
}

Future<void> showConfirmExpireInvitationDialog(
  BuildContext context,
  String invitationID,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmExpireInvitationDialog(invitationID: invitationID);
    }
  );
}

class ConfirmExpireInvitationDialog extends StatelessWidget {
  const ConfirmExpireInvitationDialog({
    required this.invitationID,
  });

  final String invitationID;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p20,
          vertical: AppPaddings.p20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15),
        ),
        child: Column( // ListView instead of Column because test keeps getting overflow error with Column
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    AdminInvitationViewText.confirmDeleteInvitation,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            gapH40,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
                        )
                      ),
                    ),
                    child: Text(
                      AdminInvitationViewText.cancelConfirmDeleteInvitation,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary
                      )
                    ),
                  )
                ),
                gapW15,
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteInvitation(invitationID, callback: () {
                        if (context.mounted) {
                          final snackBar = AppSnackBars.getSnackBar(
                            SnackBarText.invitationDeleted,
                            showCloseIcon: false,
                            snackbarType: SnackbarType.success
                          );

                          // Show SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          // Route to same view (to refresh)
                          GetIt.instance<AppDialogViewRouter>().routeToAdminListedInvitationsView(context);
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.error
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadii.r5)
                        )
                      ),
                    ),
                    child: const Text(AdminInvitationViewText.deleteInvitation)
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}