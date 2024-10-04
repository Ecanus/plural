import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class GardenTimeline extends StatefulWidget {

  @override
  State<GardenTimeline> createState() => _GardenTimelineState();
}

class _GardenTimelineState extends State<GardenTimeline> {
  final stateManager = GetIt.instance<GardenManager>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stateManager.timelineNotifier.updateValue();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: stateManager.timelineNotifier,
      builder: (BuildContext context, List<Ask> value, Widget? child) {
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p8),
            children: [ for (Ask ask in value) GardenTimelineTile(ask: ask) ],
          ),
        );
      });
  }
}