import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

class GardenTimelineTile extends StatelessWidget {
  const GardenTimelineTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;
    final authRespository = getIt<AuthRepository>();
    final currentUserUID = authRespository.getCurrentUserUID();

    return ask.creatorUID == currentUserUID ?
      EditableGardenTimelineTile(ask: ask) :
      ViewableGardenTimelineTile(ask: ask, currentUserUID: currentUserUID,);
  }
}

class ViewableGardenTimelineTile extends StatelessWidget {
  const ViewableGardenTimelineTile({
    super.key,
    required this.ask,
    required this.currentUserUID,
  });

  final Ask ask;
  final String currentUserUID;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: appLineStyle,
      startChild: BaseGardenTimelineTile(
        ask: ask,
        alignment: Alignment.centerRight,
      ),
      endChild: ask.isSponsoredByUser(currentUserUID) ?
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
          onPressed: () => createAskDialogBuilder(context),
          child: Icon(Icons.edit)
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
          color: AppColors.secondaryColor,
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
        onPressed: () => createViewableAskDialog(
          context: context,
          ask: ask),
      ),
    );

    if (isViewable) {
      widgets.add(gapW15);
      widgets.add(button);
    }

    return widgets;
  }
}