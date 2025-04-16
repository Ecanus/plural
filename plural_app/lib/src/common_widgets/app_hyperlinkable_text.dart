import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';

/// A widget for displaying text with clickable hyperlinks.
///
/// Hyperlinks should be in the format "(link_title)[link_address]". For example:
/// "Click here to visit (Google)[https://www.google.com]".
///
/// This widget uses regular expressions to identify hyperlinks in the text and
/// applies the [linkStyle] to them. The [textStyle] is applied to the rest of
/// the text.
///
/// When a hyperlink is tapped, it attempts to launch the provided URL using
/// the [url_launcher](https://pub.dev/packages/url_launcher) package. If the URL
/// is successfully launched, it opens the link in the default browser.
class AppHyperlinkableText extends StatelessWidget {
  const AppHyperlinkableText({
    this.linkStyle,
    this.maxLines,
    this.mode = LaunchMode.platformDefault,
    this.overflow = TextOverflow.clip,
    this.selectionColor,
    this.softWrap = true,
    required this.text,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.webOnlyWindowName = AppURLValues.blank,
    this.webViewConfiguration = const WebViewConfiguration(),
  });

  final TextStyle? linkStyle;
  final int? maxLines;
  final LaunchMode mode;
  final TextOverflow overflow;
  final Color? selectionColor;
  final bool softWrap;
  final String text;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final String? webOnlyWindowName;
  final WebViewConfiguration webViewConfiguration;

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    List<InlineSpan> parsedText = [];

    // Regular expression to find "[link_title](link_address)"
    RegExp linkRegex = RegExp(r'\[(.*?)\]\((.*?)\)');

    linkRegex.allMatches(text).forEach((match) {
      // Add non-link text
      parsedText.add(TextSpan(
        text: text.substring(currentIndex, match.start),
        style: textStyle,
      ));

      // Prepare gesture recognizer for tapping link
      var linkGestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        final linkText = match.group(2) ?? ""; // "[link_address]"
        final url = Uri.parse(linkText);

        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: mode,
            webOnlyWindowName: webOnlyWindowName,
            webViewConfiguration: webViewConfiguration,
          );
        }
      };

      // Add link text
      parsedText.add(
        TextSpan(
          text: match.group(1), // "(link_title)"
          style: linkStyle,
          recognizer: linkGestureRecognizer
        )
      );

      // Update index to be after the (link_title)[link_address] text
      currentIndex = match.end;
    });

    // Add remaining non-link text
    if (currentIndex < text.length) {
      parsedText.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: textStyle,
        )
      );
    }

    return SelectableText.rich(
      TextSpan(children: parsedText),
      maxLines: maxLines,
      textAlign: textAlign,
      textWidthBasis: TextWidthBasis.parent,
    );
  }
}
