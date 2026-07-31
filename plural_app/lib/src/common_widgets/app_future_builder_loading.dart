import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppFutureBuilderLoading extends StatelessWidget {

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