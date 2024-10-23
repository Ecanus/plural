import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/utils.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

Future createListedGardensDialog(BuildContext context) async {
  final listedGardenTiles = await getListedGardenTilesByUser();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: GardenDialogList(listedGardenTiles: listedGardenTiles),
          viewTitle: Strings.gardensViewTitle,
        );
      }
    );
  }
}

class GardenDialogList extends StatelessWidget {
  const GardenDialogList({
    super.key,
    required this.listedGardenTiles,
  });

  final List<ListedGardenTile> listedGardenTiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogHeader(
          firstHeaderButton: CloseDialogButton()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: listedGardenTiles,
          ),
        ),
      ],
    );
  }
}