import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitation_tile.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_listed_invitations_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AdminListedInvitationsView", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AdminListedInvitationsView(
                invitationsMap: {
                  InvitationType.open: [tc.openInvitation],
                  InvitationType.private: [tc.privateInvitation],
                }
              )
            )
          ),
        )
      );

      expect(find.byType(AdminListedInvitationsView), findsOneWidget);
      expect(find.byType(AdminListedInvitationTile), findsNWidgets(2));
      expect(find.byType(AppDialogCategoryHeader), findsNWidgets(2));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("empty lists", (tester) async {
      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: AdminListedInvitationsView(
                invitationsMap: {
                  InvitationType.open: [],
                  InvitationType.private: [],
                }
              )
            )
          ),
        )
      );

      expect(
        find.text(AdminInvitationViewText.emptyAdminListedInvitationsViewOpen),
        findsOneWidget
      );
      expect(
        find.text(AdminInvitationViewText.emptyAdminListedInvitationsViewPrivate),
        findsOneWidget
      );
    });

    tearDown(() => GetIt.instance.reset());
  });
}