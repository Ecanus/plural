import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/non_editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenTimelineTile extends StatelessWidget {
  const GardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final currentUserID = GetIt.instance<AppState>().currentUserID!;
    final isAskSponsoredByCurrentUser = ask.isSponsoredByUser(currentUserID);

    var timelineTileLineStyle = LineStyle(
      color: Theme.of(context).colorScheme.tertiaryFixed,
      thickness: AppTimelineSizes.timelineThickness,
    );

    var appIndicatorStyle = IndicatorStyle(
      color: Theme.of(context).colorScheme.tertiaryFixed,
      width: AppTimelineSizes.indicatorWidth,
    );


    return ask.creatorID == currentUserID ?
      EditableGardenTimelineTile(
        appIndicatorStyle: appIndicatorStyle,
        ask: ask,
        timelineTileLineStyle: timelineTileLineStyle
      )
      : NonEditableGardenTimelineTile(
        appIndicatorStyle: appIndicatorStyle,
        ask: ask,
        isAskSponsoredByCurrentUser: isAskSponsoredByCurrentUser,
        timelineTileLineStyle: timelineTileLineStyle
      );
  }
}

class NonEditableGardenTimelineTile extends StatelessWidget {
  const NonEditableGardenTimelineTile({
    super.key,
    required this.appIndicatorStyle,
    required this.ask,
    required this.isAskSponsoredByCurrentUser,
    required this.timelineTileLineStyle,
  });

  final IndicatorStyle appIndicatorStyle;
  final Ask ask;
  final bool isAskSponsoredByCurrentUser;
  final LineStyle timelineTileLineStyle;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: timelineTileLineStyle,
      startChild: BaseGardenTimelineTile(
        ask: ask,
        alignment: Alignment.centerRight,
      ),
      endChild: isAskSponsoredByCurrentUser ?
        Container(
          padding: const EdgeInsets.all(AppPaddings.p5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IsSponsoredIcon(),
          ),
        ) : null,
    );
  }
}

class EditableGardenTimelineTile extends StatelessWidget {
  const EditableGardenTimelineTile({
    super.key,
    required this.appIndicatorStyle,
    required this.ask,
    required this.timelineTileLineStyle,
  });

  final IndicatorStyle appIndicatorStyle;
  final Ask ask;
  final LineStyle timelineTileLineStyle;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: timelineTileLineStyle,
      startChild: Container(
        padding: const EdgeInsets.all(AppPaddings.p8),
        child: Align(
          alignment: Alignment.centerRight,
          child: TimelineAskEditButton(ask: ask),
        ),
      ),
      endChild: BaseGardenTimelineTile(
        ask: ask,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class BaseGardenTimelineTile extends StatelessWidget {
  const BaseGardenTimelineTile({
    super.key,
    required this.ask,
    required this.alignment
  });

  final Ask ask;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    bool isViewable = alignment == Alignment.centerRight;

    final MainAxisAlignment axisAlignment =
       isViewable ? MainAxisAlignment.end : MainAxisAlignment.start;

    final TextAlign textAlignment =
      isViewable ? TextAlign.end : TextAlign.start;

    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.all(AppPaddings.p10),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c375,
          height: AppConstraints.c230,
        ),
        child: Card(
          elevation: AppElevations.e7,
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: EdgeInsets.all(AppPaddings.p10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: axisAlignment,
                  children: [
                    Text(ask.formattedDeadlineDate),
                  ],
                ),
                Row(
                  mainAxisAlignment: axisAlignment,
                  children: [
                    Text(
                      ask.timeRemainingString,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                gapH25,
                Wrap(
                  runSpacing: AppRunSpacings.rs20,
                  children: [
                    Row(
                      mainAxisAlignment: axisAlignment,
                      children: [
                        Flexible(
                          child: Text(
                            ask.description,
                            textAlign: textAlignment,
                          ),
                        )
                      ]
                    ),
                    gapH60,
                    Row(
                      mainAxisAlignment: axisAlignment,
                      children: getTimelineTileFooterChildren(
                        context: context,
                        isViewable: isViewable,
                        ask: ask)
                    ),
                  ],
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTimelineTileFooterChildren({
    required BuildContext context,
    required bool isViewable,
    required Ask ask
  }) {
    List<Widget> widgets = [];

    Widget button = SizedBox(
      width: AppWidths.w25,
      height: AppHeights.h25,
      child: IconButton(
        color: AppColors.primaryColor,
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        padding: const EdgeInsets.all(AppPaddings.p0),
        onPressed: () => createNonEditableAskDialog(
          context: context,
          ask: ask
        ),
      ),
    );

    if (isViewable) {
      widgets.add(gapW15);
      widgets.add(button);
    }

    return widgets;
  }
}

class IsSponsoredIcon extends StatelessWidget {
  const IsSponsoredIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.all(AppMargins.m7),
            color: Theme.of(context).colorScheme.onSecondary
          )
        ),
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondaryFixed,
          size: AppIconSizes.s30,
        ),
      ],
    );
  }
}

class TimelineAskEditButton extends StatelessWidget {
  const TimelineAskEditButton({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppIconSizes.s35,
      height: AppIconSizes.s35,
      child: Ink(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: CircleBorder()
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.mode_edit_outlined),
          color: Theme.of(context).colorScheme.onPrimary,
          hoverColor: Theme.of(context).colorScheme.onPrimary
            .withOpacity(AppOpacities.point3),
          onPressed: () => createEditableAskDialog(
            context: context,
            ask: ask
          ),
        ),
      ),
    );
  }
}