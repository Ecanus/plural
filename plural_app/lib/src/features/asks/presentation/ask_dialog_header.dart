import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AskDialogHeader extends StatelessWidget {
  const AskDialogHeader({
    super.key,
    this.firstHeaderButton,
    this.secondHeaderButton,
    this.thirdHeaderButton,
  });

  final Widget? firstHeaderButton;
  final Widget? secondHeaderButton;
  final Widget? thirdHeaderButton;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (firstHeaderButton != null) buttons.add(firstHeaderButton!);
    if (secondHeaderButton != null) buttons.add(secondHeaderButton!);
    if (thirdHeaderButton != null) buttons.add(thirdHeaderButton!);

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints.expand(
        height: AppConstraints.c100,
        width: AppConstraints.c800,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(AppBorderRadii.r15),
          bottomLeft: Radius.circular(AppBorderRadii.r15),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons,
        )
      ),
    );
  }
}