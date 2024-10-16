import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import "package:plural_app/src/features/asks/domain/ask.dart";
import 'package:plural_app/src/features/asks/domain/ask_dialog_manager.dart';

class ListedAskTile extends StatelessWidget {
  const ListedAskTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final stateManager = GetIt.instance<AskDialogManager>();

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        title: Text(
          ask.formattedDeadlineDate,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(ask.truncatedDescription),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () { stateManager.showEditableAskDialogView(ask); },
      ),
    );
  }
}