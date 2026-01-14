import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';
import 'package:plural_app/src/features/invitations/presentation/admin_create_invitation_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("AdminCreateInvitationView", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory();
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: AppDialog(view: AdminCreateInvitationView())
        )
      );

      // Check expected values are found
      expect(find.byType(InvitationTypeDropdownMenu), findsOneWidget);
      expect(find.byType(AppTextFormField), findsOneWidget);
      expect(find.byType(AppDatePickerFormField), findsOneWidget);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogFooterBufferSubmitButton), findsOneWidget);
      expect(find.byType(AppDialogFooter), findsOneWidget);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(InvitationTypeDropdownMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text(InvitationType.open.displayName).last); // unsure why, but two widgets with "Open" are found. Use .last to get the right one to tap
      await tester.pumpAndSettle();

      // AppTextFormField should disappear when DropDown selection is InvitationType.open
      expect(find.byType(AppTextFormField), findsNothing);
    });
  });
}