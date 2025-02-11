import 'package:flutter/material.dart';

class AppDialogHeader extends StatelessWidget {
  const AppDialogHeader({
    super.key,
    this.firstHeaderButton,
    this.secondHeaderButton,
    this.thirdHeaderButton,
    this.widget,
  });

  final Widget? widget;

  final Widget? firstHeaderButton;
  final Widget? secondHeaderButton;
  final Widget? thirdHeaderButton;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    // TODO: Remove all buttonWidgets from this app
    if (firstHeaderButton != null) buttons.add(firstHeaderButton!);
    if (secondHeaderButton != null) buttons.add(secondHeaderButton!);
    if (thirdHeaderButton != null) buttons.add(thirdHeaderButton!);

    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [widget!],
        )
      ),
    );
  }
}