import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/themes.dart';

// Asks
import "package:plural_app/src/features/asks/domain/ask.dart";

class ListedAskTile extends StatelessWidget {
  const ListedAskTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    final textColor = ask.isDeadlinePassed ?
      Theme.of(context).colorScheme.onPrimaryFixed
      : Theme.of(context).colorScheme.onPrimary;
    final textDecoration = ask.isDeadlinePassed ? TextDecoration.lineThrough : null;

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        title: Text(
          ask.listedDescription,
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
            fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(
          ask.formattedDeadlineDate,
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
          ),
        ),
        trailing: TileTrailing(ask: ask),
        onTap: () {
          appDialogRouter.showEditableAskDialogView(ask);
        },
      ),
    );
  }
}

class TileTrailing extends StatelessWidget {
  const TileTrailing({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ask.isOnTimeline ?
        Ink(
          padding: EdgeInsets.all(AppPaddings.p5),
          decoration: ShapeDecoration(
            color: AppThemes.positiveColor,
            shape: CircleBorder()
          ),
          child: Icon(
            Icons.local_florist,
            size: AppIconSizes.s25,
            color: Theme.of(context).colorScheme.surface,
          ),
        )
        : SizedBox(),
        gapW20,
        Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.onSecondary
        )
      ],
    );
  }
}