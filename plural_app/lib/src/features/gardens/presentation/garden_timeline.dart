import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenTimeline extends StatelessWidget {

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
                  future: appState.getTimelineAsks(),
                  builder: (BuildContext context, AsyncSnapshot<List<Ask>> snapshot) {
                    if (snapshot.hasData) {
                      return GardenTimelineList(asks: snapshot.data!);
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
  });

  final List<Ask> asks;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(AppPaddings.p8),
        children: [
          for (Ask ask in asks) GardenTimelineTile(ask: ask)
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