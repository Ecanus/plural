import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

// Asks
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Widget that houses dimensions and theme shared across
// all Ask dialog boxes used in the app.
class AppDialog extends StatefulWidget {
  const AppDialog({
    super.key,
    required this.view,
    required this.viewTitle,
  });

  final Widget view;
  final String viewTitle;

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  final stateManager = GetIt.instance<AppDialogManager>();

  @override
  void initState() {
    super.initState();

    stateManager.dialogViewNotifier.value = widget.view;
  }

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
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: stateManager.dialogViewNotifier,
                builder: (BuildContext context, Widget view, Widget? _) {
                  return view;
                }
              )
            ),
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
                  widget.viewTitle,
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