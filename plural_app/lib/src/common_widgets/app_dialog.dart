import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

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
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c600,
              height: AppConstraints.c800,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadii.r15),
              color: Theme.of(context).colorScheme.surface.withOpacity(
                AppOpacities.point9),
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
                        color: Theme.of(context).shadowColor,
                        blurRadius: AppDialogValues.blurRadius,
                        spreadRadius: AppDialogValues.spreadRadius,
                        offset: AppDialogValues.offset,
                      ),
                    ],
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Text(
                      widget.viewTitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: AppFontSizes.s25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  )
                ),
              ],
            ),
          ),
          gapH40,
          CloseDialogButton()
        ],
      ),
    );
  }
}