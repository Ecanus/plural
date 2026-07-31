import 'package:flutter/material.dart';

class AppFutureBuilderError extends StatelessWidget {
  const AppFutureBuilderError({
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
