import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_router.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class ListedUserTile extends StatelessWidget {
  const ListedUserTile({
    super.key,
    required this.user,
  });

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final appDialogRouter = GetIt.instance<AppDialogRouter>();

    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        title: Text(
          user.username,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(""),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          appDialogRouter.showViewableUserDialogView(user);
        },
      ),
    );
  }
}