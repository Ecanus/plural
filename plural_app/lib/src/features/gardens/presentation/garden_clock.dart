import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:provider/provider.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

/// Widget for displaying today's date. Updates every 60 seconds.
class GardenClock extends StatefulWidget {
  @override
  State<GardenClock> createState() => _GardenClockState();
}

class _GardenClockState extends State<GardenClock> {
  late Timer _timer;
  late DateTime currentTime;
  late String displayedTime;

  @override
  void initState() {
    super.initState();

    currentTime = DateTime.now();
    displayedTime = DateFormat(Strings.dateformatYMMdd).format(currentTime.toLocal());

    _timer = Timer.periodic(
      const Duration(seconds: GardenValues.clockRefreshRate),
      (timer) => _update(timer)
    );
  }

  void _update(Timer timer) {
    setState(() {
      var updatedTime = DateTime.now();

      // If day has changed, update Timeline (in case of outdated deadlineDates)
      if (currentTime.day != updatedTime.day) {
        Provider.of<AppState>(context, listen: false).notifyAllListeners();
      }

      currentTime = updatedTime;
      displayedTime = DateFormat(Strings.dateformatYMMdd).format(currentTime.toLocal());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        displayedTime,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
    );
  }
}