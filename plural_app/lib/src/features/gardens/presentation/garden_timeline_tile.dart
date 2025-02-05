import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/non_editable_ask_dialog.dart';
import 'package:plural_app/src/features/asks/presentation/editable_ask_dialog.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

class GardenTimelineTile extends StatelessWidget {
  const GardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {

    var timelineTileLineStyle = LineStyle(
      color: Theme.of(context).colorScheme.tertiaryFixed,
      thickness: AppTimelineSizes.timelineThickness,
    );

    var appIndicatorStyle = IndicatorStyle(
      color: Theme.of(context).colorScheme.tertiaryFixed,
      width: AppTimelineSizes.indicatorWidth,
    );


    return ask.isCreatedByCurrentUser ?
      EditableGardenTimelineTile(
        appIndicatorStyle: appIndicatorStyle,
        ask: ask,
        timelineTileLineStyle: timelineTileLineStyle
      )
      : NonEditableGardenTimelineTile(
        appIndicatorStyle: appIndicatorStyle,
        ask: ask,
        timelineTileLineStyle: timelineTileLineStyle
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
        padding: const EdgeInsets.all(AppPaddings.p10),
        child: Align(
          alignment: Alignment.centerRight,
          child: TileEditAskButton(ask: ask),
        ),
      ),
      endChild: BaseGardenTimelineTile(ask: ask,),
    );
  }
}

class NonEditableGardenTimelineTile extends StatelessWidget {
  const NonEditableGardenTimelineTile({
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
      startChild: BaseGardenTimelineTile(ask: ask,),
      endChild: ask.isCreatedByCurrentUser ?
        Container() // Return empty Container because TimelineTile bug adds padding to the card if null is returned,
        : Container(
          padding: const EdgeInsets.all(AppPaddings.p10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TileViewAskButton(ask: ask),
          ),
        )
    );
  }
}

class BaseGardenTimelineTile extends StatelessWidget {
  const BaseGardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return TileForeground(
      ask: ask,
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
    final isSponsoredByCurrentUser = ask.isSponsoredByCurrentUser;

    return Container(
      padding: const EdgeInsets.all(AppPaddings.p10,),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        elevation: AppElevations.e10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadii.r25)
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: AppPaddings.p25,
                top: AppPaddings.p25,
                right: AppPaddings.p25,
                bottom: isSponsoredByCurrentUser ? AppPaddings.p10 : AppPaddings.p25,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "${GardenPageLabels.tileTimeLeftBrace} "),
                            TextSpan(
                              text: ask.timeRemainingString,
                              style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(text: " ${GardenPageLabels.tileTimeLeftBrace}"),
                          ]
                        )
                      ),
                    ],
                  ),
                  gapH10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Text(ask.truncatedDescription))
                    ]
                  ),
                  gapH10,
                  isSponsoredByCurrentUser ? TileIsSponsoredIcon() : SizedBox(),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileViewAskButton extends StatelessWidget {
  const TileViewAskButton({
    required this.ask
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppIconSizes.s35,
      height: AppIconSizes.s35,
      child: Ink(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.secondaryFixed,
          shape: CircleBorder()
        ),
        child: IconButton(
          color: Theme.of(context).colorScheme.onSecondary,
          icon: Icon(Icons.more_horiz_rounded,),
          onPressed: () => createNonEditableAskDialog(context: context, ask: ask),
          padding: EdgeInsets.zero
        ),
      ),
    );
  }
}

class TileEditAskButton extends StatelessWidget {
  const TileEditAskButton({
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
          color: Theme.of(context).colorScheme.onPrimary,
          icon: Icon(Icons.mode_edit_outlined),
          hoverColor: Theme.of(context).colorScheme.onPrimary
            .withOpacity(AppOpacities.point3),
          onPressed: () => createEditableAskDialog(
            context: context,
            ask: ask
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class TileIsSponsoredIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check,
      color: Theme.of(context).colorScheme.onSecondary,
      size: AppIconSizes.s15,
    );
  }
}