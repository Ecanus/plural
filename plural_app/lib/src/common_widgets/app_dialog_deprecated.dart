import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

// Widget housing the dimensions and theme shared across
// all dialog boxes used in the app.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.view,
    required this.viewTitle,
  });

  final Widget view;
  final String viewTitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints.expand(
          width: AppConstraints.c600,
          height: AppConstraints.c650,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15),
        ),
        child: Column(
          children: [
            Expanded(child: view),
            Container(
              constraints: BoxConstraints.expand(
                height: AppConstraints.c100,
                width: AppConstraints.c800,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(AppBorderRadii.r15),
                  bottomLeft: Radius.circular(AppBorderRadii.r15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onPrimaryColor,
                    blurRadius: AppDialogValues.blurRadius,
                    spreadRadius: AppDialogValues.spreadRadius,
                    offset: AppDialogValues.offset,
                  ),
                ],
                color: AppColors.darkGrey2,
              ),
              child: Center(
                child: Text(
                  viewTitle,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: AppFontSizes.s25,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}