import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

class AppDialogNavBar extends StatelessWidget {
  const AppDialogNavBar({
    super.key,
    required this.navButtons,
  });

  final List<Widget> navButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: AppConstraints.c55,
        width: AppConstraints.c800,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: navButtons,
        ),
      )
    );
  }
}