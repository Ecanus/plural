import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/utils.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_user_tile.dart';

Future createListedUsersDialog(BuildContext context) async {
  final listedUserTiles = await getListedUserTilesByUsers();

  if (context.mounted) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: UserDialogList(listedUserTiles: listedUserTiles),
          viewTitle: Strings.usersViewTitle,
        );
      }
    );
  }
}

class UserDialogList extends StatelessWidget {
  const UserDialogList({
    super.key,
    required this.listedUserTiles,
  });

  final List<ListedUserTile> listedUserTiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogHeader(
          firstHeaderButton: CloseDialogButton()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: listedUserTiles,
          ),
        ),
      ],
    );
  }
}