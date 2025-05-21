import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';

class AppDialog extends StatefulWidget {
  const AppDialog({
    required this.view,
  });

  final Widget view;

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  final _appDialogRouter = GetIt.instance<AppDialogRouter>();

  @override
  void initState() {
    super.initState();

    _appDialogRouter.setRouteTo(widget.view);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Because of ListView, need to wrap entire return in GestureDetector for custom barrierDismissable functionality
      onTap: () => {},
      child: ListView(
        padding: EdgeInsets.only(
          top: AppPaddings.p30,
        ),
        children: [
          Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector( // Wrap Container of Dialog in GestureDetector so clicking Container itself won't trigger outer GestureDetector callback
                  onTap: () {}, // Use empty callback to win out over parent GestureDetector (callbacks are first come, first serve)
                  child: Container(
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
                            valueListenable: _appDialogRouter.viewNotifier,
                            builder: (BuildContext context, Widget view, Widget? _) {
                              return view;
                            }
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                gapH37,
                CloseDialogButton()
              ],
            ),
          ),
        ],
      ),
    );
  }
}