import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Ask
import "package:plural_app/src/features/asks/data/asks_repository.dart";

Future<void> submitUpdate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final asksRepository = GetIt.instance<AsksRepository>();

    // Save form
    formKey.currentState!.save();

    // Update DB (should rebuild Garden Timeline via SubscribeTo)
    await asksRepository.update(map);

    // TODO: Wrap this method in a method that will either Close Dialog OR Reroute to Listed Asks Dialog
    // Close the Dialog
    if (context.mounted) Navigator.pop(context);
  }
}

Future<void> submitCreate(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map map
  ) async {
  if (formKey.currentState!.validate()) {
    final asksRepository = GetIt.instance<AsksRepository>();

    // Save form
    formKey.currentState!.save();

    // Update DB (should rebuild Garden Timeline via SubscribeTo)
    await asksRepository.create(map);

    // TODO: Wrap this method in a method that will either Close Dialog OR Reroute to Listed Asks Dialog
    // Close the Dialog
    if (context.mounted) Navigator.pop(context);
  }
}