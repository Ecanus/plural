import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/urls.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class ReportBugButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: AppHeights.h50,
      ),
      child: OutlinedButton(
        onPressed: () => openBugReportUrl(context),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: Theme.of(context).colorScheme.primary
            )
          )
        ),
        child: const Text(UserSettingsViewText.reportBugButton)
      ),
    );
  }
}

Future<void> openBugReportUrl(BuildContext context) async {
  var tapResult = true;
  final url = Uri.parse(Urls.bugReport);

  try {
    if (!await launchUrl(
      url,
      webOnlyWindowName: AppWebOnlyWindowNames.blank,
    )) {
      tapResult = false;
    }
  } on PlatformException {
    tapResult = false;
  }

  if (!tapResult && context.mounted) {
    final snackBar = AppSnackBars.getSnackBar(
      SnackBarText.urlError,
      boldMessage: Urls.bugReport,
      duration: AppDurations.s9,
      showCloseIcon: true,
      snackbarType: SnackbarType.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}