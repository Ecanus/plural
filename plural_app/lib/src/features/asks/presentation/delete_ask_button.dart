import 'package:flutter/material.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class DeleteAskButton extends StatelessWidget {
  const DeleteAskButton({
    required this.askID,
    this.isAdminPage = false,
  });

  final String askID;
  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50
      ),
      child: FilledButton.icon(
        icon: const Icon(Icons.delete),
        label: const Text(AskViewText.deleteAsk),
        onPressed: () => showConfirmDeleteAskDialog(context, askID, isAdminPage),
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

Future<void> showConfirmDeleteAskDialog(
  BuildContext context,
  String askID,
  bool isAdminPage,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmDeleteAskDialog(askID: askID, isAdminPage: isAdminPage,);
    }
  );
}

class ConfirmDeleteAskDialog extends StatelessWidget {
  const ConfirmDeleteAskDialog({
    required this.askID,
    required this.isAdminPage,
  });

  final String askID;
  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p20,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c400,
          height: AppConstraints.c180
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
                  AskViewText.confirmDeleteAsk,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            gapH35,
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
                      AskViewText.cancelConfirmDeleteAsk,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                    )
                  ),
                ),
                gapW15,
                Container(
                  constraints: BoxConstraints(minHeight: AppHeights.h40),
                  child: FilledButton(
                    onPressed: () {
                      // Close confirmation, then close the examine/edit ask view
                      Navigator.pop(context);
                      Navigator.pop(context);
                      deleteAsk(
                        context,
                        askID,
                        isAdminPage: isAdminPage,
                        callback: () {
                          if (context.mounted) {
                            final snackBar = AppSnackBars.getSnackBar(
                              SnackBarText.deleteAskSuccess,
                              showCloseIcon: false,
                              snackbarType: SnackbarType.success
                            );

                            // Display Success Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    child: const Text(AskViewText.deleteAsk)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}