import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/themes.dart';

// Asks
import "package:plural_app/src/features/asks/domain/ask.dart";

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';

class ListedAskTile extends StatelessWidget {
  const ListedAskTile({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    final shouldStrikethrough = ask.isDeadlinePassed || ask.targetMetDate != null;
    final textDecoration = shouldStrikethrough ? TextDecoration.lineThrough : null;
    final textColor = shouldStrikethrough ?
      Theme.of(context).colorScheme.onPrimaryFixed
      : Theme.of(context).colorScheme.onPrimary;

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          ask.listTileDescription,
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
            fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(
          "${AskDialogText.deadlineDueBy}: ${ask.formattedDeadlineDate}",
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: TileTrailing(isOnTimeline: ask.isOnTimeline),
        onTap: () {
          Future.delayed(AppDurations.ms80, () {
            appDialogRouter.routeToEditableAskDialogView(ask);
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
        CircleAvatar(
          backgroundColor: AppThemes.positiveColor,
          radius: AppBorderRadii.r15,
          child: Icon(
            Icons.local_florist,
            size: AppIconSizes.s20,
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