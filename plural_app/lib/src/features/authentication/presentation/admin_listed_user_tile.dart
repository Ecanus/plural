import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

class AdminListedUserTile extends StatelessWidget {
  const AdminListedUserTile({
    required this.userGardenRecord,
  });

  final AppUserGardenRecord userGardenRecord;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    final isCurrentUser =
      GetIt.instance<AppState>().currentUser! == userGardenRecord.user;

    final isEditable = [
      AppUserGardenRole.administrator,
      AppUserGardenRole.member
    ].contains(userGardenRecord.role);

    return Card(
      elevation: isEditable ? AppElevations.e7 : null,
      child: ListTile(
        leading: isCurrentUser ?
          Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary
          ) : null,
        tileColor: isEditable ?
          Theme.of(context).colorScheme.secondaryFixed
          : Theme.of(context).colorScheme.secondary,
        title: Text(
          userGardenRecord.user.username,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500
          ),
        ),
        trailing: isEditable ?
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.onSecondary
          ) : SizedBox(),
        onTap: isEditable ? () {
          appDialogViewRouter.routeToAdminEditUserView(userGardenRecord);
        } : null,
      ),
    );
  }
}