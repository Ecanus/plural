import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

/// Widget for displaying today's date. Updates every 60 seconds.
class GardenClock extends StatefulWidget {
  @override
  State<GardenClock> createState() => _GardenClockState();
}

class _GardenClockState extends State<GardenClock> {
  String formattedTime = DateFormat(Strings.dateformatYMMdd).format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 60), (timer) => _update(timer));
  }

  void _update(Timer timer) {
    setState(() {
      formattedTime = DateFormat(Strings.dateformatYMMdd).format(DateTime.now());
    });
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