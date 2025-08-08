import 'package:flutter/material.dart' show BuildContext, ScaffoldMessenger;
import 'package:flutter/services.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

/// Copies the given [content] to the system's clipboard.
Future<void> copyToClipboard(BuildContext context, String content) async {
  await Clipboard.setData(ClipboardData(text: content));

  if (context.mounted) {
    // Display SnackBar
    final snackBar = AppSnackBars.getSnackBar(
      SnackBarText.copiedToClipboard,
      showCloseIcon: false,
      snackbarType: SnackbarType.success
    );

    // Display Success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}