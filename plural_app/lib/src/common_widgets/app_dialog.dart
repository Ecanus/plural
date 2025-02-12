import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Widget that houses dimensions and theme shared across
// all Ask dialog boxes used in the app.
class AppDialog extends StatefulWidget {
  const AppDialog({
    super.key,
    this.buttons,
    required this.view,
    required this.viewTitle,
  });

  final List<Widget>? buttons;
  final Widget view;
  final String viewTitle;

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  final appDialogRouter = GetIt.instance<AppDialogRouter>();

  @override
  void initState() {
    super.initState();

    appDialogRouter.viewNotifier.value = widget.view;
    appDialogRouter.viewFooterBufferNotifier.value = widget.buttons ?? [];
    appDialogRouter.viewFooterNotifier.value = widget.viewTitle;
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
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: appDialogRouter.viewNotifier,
                    builder: (BuildContext context, Widget view, Widget? _) {
                      return view;
                    }
                  )
                ),
                ValueListenableBuilder(
                  valueListenable: appDialogRouter.viewFooterBufferNotifier,
                  builder: (BuildContext context, List<Widget> buttons, Widget? _) {
                    return AppDialogFooterBuffer(buttons: buttons);
                  }
                ),
                ValueListenableBuilder(
                  valueListenable: appDialogRouter.viewFooterNotifier,
                  builder: (BuildContext context, String footerTitle, Widget? _) {
                    return AppDialogFooter(title: footerTitle);
                  }
                ),
              ],
            ),
          ),
          gapH37,
          CloseDialogButton()
        ],
      ),
    );
  }
}

class AppDialogFooterBuffer extends StatelessWidget {
  const AppDialogFooterBuffer({
    super.key,
    required this.buttons,
  });

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return buttons.isNotEmpty ?
      Container(
        constraints: BoxConstraints.expand(
          width: AppConstraints.c600,
          height: AppConstraints.c60,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: AppDialogValues.blurRadius,
              spreadRadius: AppDialogValues.spreadRadius,
              offset: AppDialogValues.offset,
            ),
          ],
          color: Theme.of(context).colorScheme.surfaceBright,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons,
        ),
      )
      : SizedBox();
  }
}

class AppDialogFooter extends StatelessWidget {
  const AppDialogFooter({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: AppConstraints.c800,
        height: AppConstraints.c100,
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
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppFontSizes.s25,
            fontWeight: FontWeight.bold,
          ),
        )
      )
    );
  }
}