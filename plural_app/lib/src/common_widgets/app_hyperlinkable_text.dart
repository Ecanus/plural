import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';
import 'package:plural_app/src/localization/lang_en.dart';
import 'package:url_launcher/url_launcher.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';

/// Source code taken and adapted from
/// https://github.com/Odinachi/hyperlink/blob/master/lib/src/hyperlink_impl.dart
///
/// _disposeFunctions is implemented as per suggestion of:
/// https://stackoverflow.com/a/78825170 to avoid memory leaks, as it is stated that
/// TapGestureRecognizer does not dispose of itself.
class AppHyperlinkableText extends StatefulWidget {
  const AppHyperlinkableText({
    this.linkStyle,
    this.maxLines,
    this.mode = LaunchMode.platformDefault,
    required this.text,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.webOnlyWindowName = AppURLValues.blank,
    this.webViewConfiguration = const WebViewConfiguration(),
  });

  final TextStyle? linkStyle;
  final int? maxLines;
  final LaunchMode mode;
  final String text;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final String? webOnlyWindowName;
  final WebViewConfiguration webViewConfiguration;

  @override
  State<AppHyperlinkableText> createState() => _AppHyperlinkableTextState();
}

class _AppHyperlinkableTextState extends State<AppHyperlinkableText> {
  late List<Function> _disposeFunctions;

  @override
  void initState() {
    super.initState();
    _disposeFunctions = [];
  }

  @override
  void dispose() {
    for (Function disposeFunction in _disposeFunctions) {
      disposeFunction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    List<InlineSpan> parsedText = [];

    // Regular expression to find "[link_title](link_address)"
    RegExp linkRegex = RegExp(r'\[(.*?)\]\((.*?)\)');

    linkRegex.allMatches(widget.text).forEach((match) {
      // Add non-link text
      parsedText.add(TextSpan(
        text: widget.text.substring(currentIndex, match.start),
        style: widget.textStyle,
      ));

      // Prepare gesture recognizer for tapping link
      var linkGestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        final linkText = match.group(2) ?? ""; // "[link_address]"
        final url = Uri.parse(linkText);

        var tapResult = true;
        try {
          if (!await launchUrl(
            url,
            mode: widget.mode,
            webOnlyWindowName: widget.webOnlyWindowName,
            webViewConfiguration: widget.webViewConfiguration,
          )) {
            tapResult = false;
          }
        } on PlatformException {
          tapResult = false;
        }

        // If the tap did not work, display error Snackbar
        if (!tapResult && context.mounted) {
          var snackBar = AppSnackbars.getSnackbar(
            SnackbarText.urlError,
            boldMessage: linkText,
            duration: AppDurations.s9,
            showCloseIcon: true,
            snackbarType: SnackbarType.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      };
      // Add this TapGestureRecognizer's dispose to _disposeFunctions
      _disposeFunctions.add(linkGestureRecognizer.dispose);

      // Add link text
      parsedText.add(
        TextSpan(
          text: match.group(1), // "(link_title)"
          style: widget.linkStyle,
          recognizer: linkGestureRecognizer
        )
      );

      // Update index to be after the (link_title)[link_address] text
      currentIndex = match.end;
    });

    // Add remaining non-link text
    if (currentIndex < widget.text.length) {
      parsedText.add(
        TextSpan(
          text: widget.text.substring(currentIndex),
          style: widget.textStyle,
        )
      );
    }

    return SelectableText.rich(
      TextSpan(children: parsedText),
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      textWidthBasis: TextWidthBasis.parent,
    );
  }
}
