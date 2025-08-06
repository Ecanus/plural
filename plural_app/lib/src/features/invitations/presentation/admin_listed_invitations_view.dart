import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitation_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class AdminListedInvitationsView extends StatelessWidget {
  const AdminListedInvitationsView({
    required this.invitationsMap,
  });

  final Map<InvitationType, List<Invitation>> invitationsMap;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              AppDialogCategoryHeader(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: AppFontSizes.s20,
                fontWeight: FontWeight.w500,
                text: AdminInvitationViewText.privateInvitations,
              ),
              gapH10,
              SizedBox(
                height: AppHeights.h250,
                child: ListView.builder(
                  itemCount: invitationsMap[InvitationType.private]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AdminListedInvitationTile(
                      invitation: invitationsMap[InvitationType.private]![index]
                    );
                  },
                ),
              ),
              gapH40,
              AppDialogCategoryHeader(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: AppFontSizes.s20,
                fontWeight: FontWeight.w500,
                text: AdminInvitationViewText.openInvitations
              ),
              gapH10,
              SizedBox(
                height: AppHeights.h250,
                child: ListView.builder(
                  itemCount: invitationsMap[InvitationType.open]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AdminListedInvitationTile(
                      invitation: invitationsMap[InvitationType.open]![index]
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              icon: Icons.arrow_back,
              message: AdminInvitationViewText.returnToAdminOptions,
              callback: appDialogViewRouter.routeToAdminOptionsView
            ),
            RouteToViewButton(
              icon: Icons.add,
              message: AdminInvitationViewText.createInvitation,
              callback: appDialogViewRouter.routeToAdminCreateInvitationView
            ),
          ]
        ),
        AppDialogFooter(title: AppDialogFooterText.adminListedInvitations)
      ],
    );
  }
}