import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/strings.dart';

/// Widget for displaying today's date. Updates every 60 seconds.
class GardenClock extends StatefulWidget {
  @override
  State<GardenClock> createState() => _GardenClockState();
}

class _GardenClockState extends State<GardenClock> {
  late Timer _timer;
  String formattedTime = DateFormat(Strings.dateformatYMMdd).format(DateTime.now());

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: GardenValues.clockRefreshRate),
      (timer) => _update(timer)
    );
  }

  void _update(Timer timer) {
    setState(() {
      formattedTime = DateFormat(Strings.dateformatYMMdd).format(DateTime.now());
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
        formattedTime,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
    );
  }
}