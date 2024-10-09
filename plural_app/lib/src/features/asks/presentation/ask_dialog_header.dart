import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AskDialogHeader extends StatelessWidget {
  const AskDialogHeader({
    super.key,
    this.primaryHeaderButton,
    this.secondaryHeaderButton,
  });

  final Widget? primaryHeaderButton;
  final Widget? secondaryHeaderButton;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [CloseDialogButton()];
    if (primaryHeaderButton != null) buttons.add(primaryHeaderButton!);
    if (secondaryHeaderButton != null) buttons.add(secondaryHeaderButton!);

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