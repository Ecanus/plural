import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

class SponsoredAskTile extends StatelessWidget {
  const SponsoredAskTile({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          ask.listTileDescription,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          ask.timeRemainingString,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Future.delayed(AppDurations.ms80, () {
            appDialogViewRouter.routeToExamineAskView(ask);
          });
        },
      )
    );
  }
}