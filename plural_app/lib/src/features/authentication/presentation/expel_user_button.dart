import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

class ExpelUserButton extends StatelessWidget {
  const ExpelUserButton({
    required this.userGardenRecord,
  });

  final AppUserGardenRecord userGardenRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50
      ),
      child: FilledButton.icon(
        icon: const Icon(Icons.close),
        label: Text(
          "${AdminListedUsersViewText.expelUserPrefix} ${userGardenRecord.user.username}"
        ),
        onPressed: () => showConfirmExpelUserDialog(context, userGardenRecord),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
           Theme.of(context).colorScheme.error
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          )
        ),
      ),
    );
  }
}

Future<void> showConfirmExpelUserDialog(
  BuildContext context,
  AppUserGardenRecord userGardenRecord,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmExpelUserDialog(userGardenRecord: userGardenRecord);
    }
  );
}

class ConfirmExpelUserDialog extends StatelessWidget {
  const ConfirmExpelUserDialog({
    required this.userGardenRecord,
  });

  final AppUserGardenRecord userGardenRecord;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p30,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c500,
          height: AppConstraints.c250,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AdminListedUsersViewText.confirmExpelUser,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ]
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    AdminListedUsersViewText.confirmExpelUserSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
            gapH50,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                      AdminListedUsersViewText.cancelConfirmExpelUser,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
                gapW15,
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: FilledButton(
                    onPressed: () => expelUserFromGarden(
                      context,
                      userGardenRecord,
                      callback: () {
                        GetIt.instance<AppDialogViewRouter>()
                          .routeToAdminListedUsersView(context);

                        final snackBar = AppSnackBars.getSnackBar(
                          SnackBarText.expelUserSuccess,
                          boldMessage: userGardenRecord.user.username,
                          duration: AppDurations.s9,
                          snackbarType: SnackbarType.success
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    ),
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
                    child: const Text(AdminListedUsersViewText.expelUser),
                  )
                ),
              ],
            ),
          ]
        ),
      )
    );
  }
}
