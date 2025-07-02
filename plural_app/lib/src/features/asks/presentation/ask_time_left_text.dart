import 'package:flutter/material.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class AskTimeLeftText extends StatelessWidget {
  const AskTimeLeftText({
    required this.ask,
    this.fontSize,
    required this.textColor,
  });

  final Ask ask;
  final double? fontSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              style: TextStyle(
                color: textColor,
                fontSize: fontSize
              ),
              text: "${AskViewText.askTimeLeftBrace} "
            ),
            TextSpan(
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold
              ),
              text: ask.timeRemainingString,
            ),
            TextSpan(
              style: TextStyle(
                color: textColor,
                fontSize: fontSize
              ),
              text: " ${AskViewText.askTimeLeftBrace}"
            ),
          ]
        )
      ),
    );
  }
}