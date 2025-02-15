import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Asks
import "package:plural_app/src/features/asks/domain/ask.dart";
import 'package:plural_app/src/features/asks/presentation/listed_asks_button.dart';

class ListedAskTile extends StatelessWidget {
  const ListedAskTile({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final stateManager = GetIt.instance<AppDialogManager>();

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        title: Text(
          ask.formattedDeadlineDate,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(ask.truncatedDescription),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          stateManager.showEditableAskDialogView(
            ask,
            firstHeaderButton: ListedAsksButton()
          );
        },
      ),
    );
  }
}