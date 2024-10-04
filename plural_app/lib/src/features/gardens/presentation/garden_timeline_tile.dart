import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

var testLoggedInUserUID = "TESTUSER1";

class GardenTimelineTile extends StatelessWidget {
  const GardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return ask.creatorUID == testLoggedInUserUID ?
      EditableGardenTimelineTile(ask: ask) :
      ViewableGardenTimelineTile(ask: ask);
  }
}

class ViewableGardenTimelineTile extends StatelessWidget {
  const ViewableGardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: appLineStyle,
      startChild: BaseGardenTimelineTile(
        tileDate: ask.formattedDeadlineDate,
        tileTimeRemaining: ask.timeRemainingString,
        tileText: ask.description,
        alignment: Alignment.centerRight,
      ),
      endChild: ask.isSponsoredByUser(testLoggedInUserUID) ?
        Container(
          padding: const EdgeInsets.all(AppPaddings.p5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: AppIconSizes.s30
            ),
          ),
        ) : null,
    );
  }
}

class EditableGardenTimelineTile extends StatelessWidget {
  const EditableGardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: appLineStyle,
      startChild: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: AppElevations.e5,
            padding: const EdgeInsets.all(AppPaddings.p15),
            shape: CircleBorder(),
            iconColor: AppColors.secondaryColor,
            backgroundColor: AppColors.primaryColor
          ),
          onPressed: () => dialogBuilder(context),
          child: Icon(Icons.edit)
        ),
      ),
      endChild: BaseGardenTimelineTile(
        tileDate: ask.formattedDeadlineDate,
        tileTimeRemaining: ask.timeRemainingString,
        tileText: ask.description,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class BaseGardenTimelineTile extends StatelessWidget {
  const BaseGardenTimelineTile({
    super.key,
    required this.tileDate,
    required this.tileTimeRemaining,
    required this.tileText,
    required this.alignment
  });

  final String tileDate;
  final String tileTimeRemaining;
  final String tileText;
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
          color: AppColors.secondaryColor,
          child: Padding(
            padding: EdgeInsets.all(AppPaddings.p10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: axisAlignment,
                  children: [
                    Text(tileDate),
                  ],
                ),
                Row(
                  mainAxisAlignment: axisAlignment,
                  children: [
                    Text(
                      tileTimeRemaining,
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
                            tileText,
                            textAlign: textAlignment,
                          ),
                        )
                      ]
                    ),
                    gapH60,
                    Row(
                      mainAxisAlignment: axisAlignment,
                      children: getTimelineTileFooterChildren(context, isViewable)
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

  List<Widget> getTimelineTileFooterChildren(
    BuildContext context, bool isViewable) {
    List<Widget> widgets = [];

    Widget tag = OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppBorderRadii.r5)),
        ),
      ),
      child: Text("Groceries"),
    );

    Widget button = SizedBox(
      width: AppWidths.w25,
      height: AppHeights.h25,
      child: IconButton(
        color: AppColors.primaryColor,
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        padding: const EdgeInsets.all(AppPaddings.p0),
        onPressed: () => dialogBuilder(context),
      ),
    );

    if (isViewable) {
      widgets.add(tag);
      widgets.add(gapW15);
      widgets.add(button);
    } else {
      widgets.add(tag);
    }

    return widgets;
  }
}

Future dialogBuilder(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("TO REMOVE Dialog Title"),
        children: [
          SimpleDialogOption(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text("Click to close"),
          )
        ],
      );
    }
  );
}