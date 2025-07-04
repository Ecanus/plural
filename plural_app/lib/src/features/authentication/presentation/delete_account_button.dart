import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/styles.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50,
      ),
      child: FilledButton.icon(
        icon: const Icon(Icons.delete),
        label: const Text(LandingPageText.deleteAccount),
        onPressed: () => showConfirmDeleteAccountDialog(context),
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
      ),
    );
  }
}

Future<void> showConfirmDeleteAccountDialog(
  BuildContext context,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmDeleteAccountDialog();
    }
  );
}

class ConfirmDeleteAccountDialog extends StatefulWidget {

  @override
  State<ConfirmDeleteAccountDialog> createState() => _ConfirmDeleteAccountDialogState();
}

class _ConfirmDeleteAccountDialogState extends State<ConfirmDeleteAccountDialog> {
  var _autoFocus = true;
  var _isTextMatch = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controller.removeListener(_controllerListener);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller.text = "";
    _controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {
      _isTextMatch = _controller.text == LandingPageText.confirmDeleteAccountValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.p50,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c600,
          height: AppConstraints.c350,
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
                  LandingPageText.confirmDeleteAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    LandingPageText.confirmDeleteAccountSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            gapH35,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(""
                  "${LandingPageText.confirmDeleteAccountPrompt} "
                  "'${LandingPageText.confirmDeleteAccountValue}'"
                ),
              ],
            ),
            gapH10,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    autofocus: _autoFocus,
                    controller: _controller,
                    decoration: InputDecoration(
                      border: AppStyles.textFieldBorder,
                      enabledBorder: AppStyles.textFieldBorder,
                      focusedBorder: AppStyles.textFieldFocusedBorder,
                    ),
                  ),
                ),
              ],
            ),
            gapH20,
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
                      LandingPageText.cancelConfirmDeleteAccount,
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
                    onPressed: _isTextMatch ? () {
                      deleteCurrentUserAccount(context: context);
                    }
                    : null,
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
                    child: const Text(LandingPageText.deleteAccount)
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