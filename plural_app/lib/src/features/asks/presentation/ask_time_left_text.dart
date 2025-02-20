import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

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
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            style: TextStyle(
              color: textColor,
              fontSize: fontSize
            ),
            text: "${GardenPageLabels.tileTimeLeftBrace} "
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
            text: " ${GardenPageLabels.tileTimeLeftBrace}"
          ),
        ]
      )
    );
  }
}