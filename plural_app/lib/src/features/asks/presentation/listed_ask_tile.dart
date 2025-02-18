import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';
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

    final shouldStrikethrough = ask.isDeadlinePassed || ask.targetMetDate != null;

    final textColor = shouldStrikethrough ?
      Theme.of(context).colorScheme.onPrimaryFixed
      : Theme.of(context).colorScheme.onPrimary;
    final textDecoration = shouldStrikethrough ? TextDecoration.lineThrough : null;

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          ask.listedDescription,
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
            fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(
          "${AskDialogLabels.deadlineDueBy}: ${ask.formattedDeadlineDate}",
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: TileTrailing(isOnTimeline: ask.isOnTimeline),
        onTap: () {
          Future.delayed(FormValues.listedAskTileClickDelay, () {
            appDialogRouter.showEditableAskDialogView(ask);
          });
        },
      ),
    );
  }
}

class TileTrailing extends StatelessWidget {
  const TileTrailing({
    required this.isOnTimeline,
  });

  final bool isOnTimeline;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isOnTimeline ?
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
        gapW10,
        Icon(
          Icons.arrow_forward_ios,
          color: isOnTimeline ?
          AppThemes.positiveColor
          : Theme.of(context).colorScheme.onSecondary
        )
      ],
    );
  }
}