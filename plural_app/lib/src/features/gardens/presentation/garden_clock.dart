import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Constants
import 'package:plural_app/src/constants/formats.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/constants.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardenClock extends StatefulWidget {
  @override
  State<GardenClock> createState() => _GardenClockState();
}

class _GardenClockState extends State<GardenClock> {
  late DateTime _currentTime;
  late String _displayedTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _currentTime = DateTime.now();
    _displayedTime = DateFormat(Formats.dateYMMdd).format(_currentTime.toLocal());

    _timer = Timer.periodic(
      const Duration(seconds: GardenConstants.clockRefreshRate),
      (timer) => _update(timer)
    );
  }

  void _update(Timer timer) {
    setState(() {
      var updatedTime = DateTime.now();

      // If day has changed, update Timeline (in case of outdated deadlineDates)
      if (_currentTime.day != updatedTime.day) {
        Provider.of<AppState>(context, listen: false).notifyAllListeners();
      }

      _currentTime = updatedTime;
      _displayedTime = DateFormat(Formats.dateYMMdd).format(_currentTime.toLocal());
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
        _displayedTime,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
    );
  }
}