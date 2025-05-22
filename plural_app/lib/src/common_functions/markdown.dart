import 'package:flutter/material.dart';

/// Parses through the given [text] and creates a list of
/// [InlineSpan], converting "[link_text](link_address)" text into only "link_text".
///
/// Returns the list of [InlineSpan] of the given [text].
List<InlineSpan> stripHttpMarkdown({
  required String text,
  TextStyle? textStyle,
}) {
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

    // Add link text
    parsedText.add(
      TextSpan(text: match.group(1)) // "[link_title]"
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

  return parsedText;
}