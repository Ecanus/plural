import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';
import 'package:plural_app/src/common_widgets/app_dialog_manager.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header_button.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/utils.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

Future createListedAsksDialog(BuildContext context) async {
  final listedAskTiles = await getListedAskTilesByAsks();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AskDialogList(listedAskTiles: listedAskTiles),
          viewTitle: Strings.asksViewTitle,
        );
      }
    );
  }
}

class AskDialogList extends StatelessWidget {
  const AskDialogList({
    super.key,
    required this.listedAskTiles,
  });

  final List<ListedAskTile> listedAskTiles;

  @override
  Widget build(BuildContext context) {
    final stateManager = GetIt.instance<AppDialogManager>();

    final Widget creatableAskViewButton = AppDialogHeaderButton(
      buttonNotifier: ValueNotifier<bool>(true),
      onPressed: () { stateManager.showCreatableAskDialogView(); },
      icon: Icon(Icons.add_comment),
      label: Strings.newAskLabel
    );

    return Column(
      children: [
        AppDialogHeader(
          firstHeaderButton: CloseDialogButton(),
          secondHeaderButton: creatableAskViewButton,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: listedAskTiles,
          ),
        ),
      ],
    );
  }
}