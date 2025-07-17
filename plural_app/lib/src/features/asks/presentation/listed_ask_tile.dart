import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

class ListedAskTile extends StatelessWidget {
  const ListedAskTile({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    final shouldStrikethrough = ask.isDeadlinePassed || ask.targetMetDate != null;
    final textDecoration = shouldStrikethrough ? TextDecoration.lineThrough : null;
    final textColor = shouldStrikethrough ?
      Theme.of(context).colorScheme.onPrimaryFixed
      : Theme.of(context).colorScheme.onPrimary;

    final tileTrailingAvatar = getTileTrailingAvatar(
      context, ask.isOnTimeline, ask.isTargetMet
    );

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
          "${AskViewText.deadlineDueBy}: ${ask.formattedDeadlineDate}",
          style: TextStyle(
            color: textColor,
            decoration: textDecoration,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: ListedAskTileTrailing(tileTrailingAvatar: tileTrailingAvatar),
        onTap: () {
          Future.delayed(AppDurations.ms80, () {
            appDialogViewRouter.routeToEditAskView(ask);
          });
        },
      ),
    );
  }
}

class ListedAskTileTrailing extends StatelessWidget {
  const ListedAskTileTrailing({
    required this.tileTrailingAvatar,
  });

  final Widget tileTrailingAvatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        tileTrailingAvatar,
        gapW10,
        Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.onSecondary
        )
      ],
    );
  }
}

Widget getTileTrailingAvatar(context, isOnTimeline, isTargetMet) {
  if (isOnTimeline) {
    return CircleAvatar(
      backgroundColor: AppThemes.positiveColor,
      radius: AppBorderRadii.r15,
      child: Icon(
        Icons.local_florist,
        size: AppIconSizes.s20,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
  if (isTargetMet) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: AppBorderRadii.r15,
      child: Icon(
        Icons.check,
        size: AppIconSizes.s20,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  return SizedBox();
}