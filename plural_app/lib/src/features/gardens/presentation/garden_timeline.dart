import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenTimeline extends StatelessWidget {
  const GardenTimeline({
    this.isAdminPage = false,
  });

  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(maxWidth: AppConstraints.c1000),
        child: Row(
          children: [
            Consumer<AppState>(
              builder: (_, appState, __) {
                return FutureBuilder<List<Ask>>(
                  future: appState.getTimelineAsks(context, isAdminPage: isAdminPage),
                  builder: (BuildContext context, AsyncSnapshot<List<Ask>> snapshot) {
                    if (snapshot.hasData) {
                      return GardenTimelineList(
                        asks: snapshot.data!, isAdminPage: isAdminPage);
                    } else if (snapshot.hasError) {
                      return GardenTimelineError(error: snapshot.error);
                    } else {
                      return GardenTimelineLoading();
                    }
                  }
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

class GardenTimelineList extends StatelessWidget {
  const GardenTimelineList({
    required this.asks,
    required this.isAdminPage,
  });

  final List<Ask> asks;
  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: asks.isEmpty ?
        EmptyTimelineMessage() :
        ListView(
          padding: const EdgeInsets.all(AppPaddings.p8),
          children: [
            for (int index = 0; index < asks.length; index++)
              GardenTimelineTile(
                ask: asks[index],
                index: index,
                isAdminPage: isAdminPage
              )
          ],
        ),
    );
  }
}

class EmptyTimelineMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_food_beverage,
            size: AppIconSizes.s40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          gapH5,
          Text(
            GardenTimelineText.emptyTimelineMessage,
            style: Theme.of(context).textTheme.headlineSmall
          ),
          gapH10,
          Text(
            GardenTimelineText.emptyTimelineSubtitle,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ],
      ),
    );
  }
}

class GardenTimelineError extends StatelessWidget {
  const GardenTimelineError({
    this.error,
  });

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text("$error")),
    );
  }
}

class GardenTimelineLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: AppWidths.w60,
          height: AppHeights.h60,
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}