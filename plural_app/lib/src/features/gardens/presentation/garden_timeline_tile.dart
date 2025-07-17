import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/admin_examine_ask_view.dart';
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';
import 'package:plural_app/src/features/asks/presentation/examine_ask_view.dart';

class GardenTimelineTile extends StatelessWidget {
  const GardenTimelineTile({
    required this.ask,
    required this.index,
    required this.isAdminPage,
  });

  final Ask ask;
  final int index;
  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    final examineButtonContainer = Container(
      padding: const EdgeInsets.all(AppPaddings.p10),
      child: Align(
        alignment: (index % 2 == 0) ? Alignment.centerLeft : Alignment.centerRight,
        child: TileExamineAskButton(ask: ask, isAdminPage: isAdminPage),
      ),
    );

    final timelineTileStack = Stack(
      children: [
        TileBackground(ask: ask, index: index),
        TileForeground(ask: ask),
      ],
    );

    final widgets = (index % 2 == 0) ?
      [timelineTileStack, examineButtonContainer]
      : [examineButtonContainer, timelineTileStack];

    return TimelineTile(
      alignment: TimelineAlign.center,
      beforeLineStyle: LineStyle(
        color: Theme.of(context).colorScheme.tertiaryFixed,
        thickness: AppTimelineSizes.timelineThickness,
      ),
      indicatorStyle: IndicatorStyle(
        color: Theme.of(context).colorScheme.tertiaryFixed,
        width: AppTimelineSizes.indicatorWidth,
      ),
      startChild: widgets[0],
      endChild: widgets[1],
    );
  }
}

class TileBackground extends StatelessWidget {
  const TileBackground({
    required this.ask,
    required this.index,
  });

  final Ask ask;
  final int index;

  @override
  Widget build(BuildContext context) {
    final sign = (index % 2 == 0) ? -1 : 1;

    return RotationTransition(
      turns: AlwaysStoppedAnimation(sign * AppRotations.degrees10),
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.p20),
        child: Card.filled(
          color: Theme.of(context).colorScheme.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadii.r25),
          ),
          child: TileContents(ask: ask, hasHiddenContent: true)
        ),
      ),
    );
  }
}

class TileForeground extends StatelessWidget {
  const TileForeground({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddings.p10,),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        elevation: AppElevations.e10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadii.r25)
        ),
        child: TileContents(ask: ask),
      ),
    );
  }
}

class TileContents extends StatelessWidget {
  const TileContents({
    required this.ask,
    this.hasHiddenContent = false,
  });

  final Ask ask;
  final bool hasHiddenContent;

  @override
  Widget build(BuildContext context) {
    final textColor = hasHiddenContent ?
      Colors.transparent : Theme.of(context).colorScheme.onPrimary;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.p25,
            top: AppPaddings.p25,
            right: AppPaddings.p25,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AskTimeLeftText(textColor: textColor, ask: ask)
                  ),
                ],
              ),
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      ask.truncatedDescription,
                      style: TextStyle(color: textColor),
                    )
                  )
                ]
              ),
              gapH20,
            ]
          ),
        ),
      ],
    );
  }
}

class TileExamineAskButton extends StatelessWidget {
  const TileExamineAskButton({
    required this.ask,
    required this.isAdminPage,
  });

  final Ask ask;
  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppIconSizes.s35,
      height: AppIconSizes.s35,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        child: IconButton(
          color: Theme.of(context).colorScheme.secondaryFixed,
          icon: const Icon(Icons.more_horiz_rounded),
          onPressed: () => isAdminPage ?
            createAdminExamineAskDialog(context: context, ask: ask)
            : createExamineAskDialog(context: context, ask: ask),
          padding: EdgeInsets.zero
        ),
      ),
    );
  }
}