import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pocketbase/pocketbase.dart';

// Plural
import 'package:plural_app/src/app.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer_nav_button.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_listed_garden_tile.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';
import 'package:plural_app/src/features/invitations/presentation/landing_page_invitation_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../test/test_factories.dart';
import '../test/test_mocks.dart';
import '../test/test_stubs/app_test_stubs.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('app_test', () {
    testWidgets("member login_logout", (tester) async {
      final now = DateTime.now();

      // Users
      final user = AppUserFactory();
      final otherUser = AppUserFactory();

      // User Settings
      final userSettings = AppUserSettingsFactory(user: user);

      // Gardens
      final garden = GardenFactory();
      final otherGarden = GardenFactory();

      // User Garden Records
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        role: AppUserGardenRole.member,
        user: user,
      );
      // User Garden Records
      final otherUserGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        role: AppUserGardenRole.member,
        user: otherUser,
      );

      // Asks
      final ask = AskFactory(
        creator: user,
        deadlineDate: now.add(const Duration(days: 2))
      );
      final otherAsk = AskFactory(creator: otherUser,);

      // Invitations
      final privateInvitation = InvitationFactory(
        invitee: user,
        garden: otherGarden,
        type: InvitationType.private
      );

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.authStore
      final authStore = AuthStore();

      appTestSetupStub(
        ask: ask,
        authStore: authStore,
        garden: garden,
        otherAsk: otherAsk,
        otherGarden: otherGarden,
        otherUser: otherUser,
        otherUserGardenRecord: otherUserGardenRecord,
        pb: pb,
        privateInvitation: privateInvitation,
        recordService: recordService,
        user: user,
        userGardenRecord: userGardenRecord,
        userSettings: userSettings);


      await tester.pumpWidget(MyApp(database: pb));

      // Enter username and password
      await tester.enterText(find.byType(AppTextFormField), user.username);
      await tester.enterText(find.byType(LogInPasswordFormField), "testuserpassword");

      // Tap on Log In button
      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      // Tap on Icons.mail to go to Invitations tab
      await tester.tap(find.byIcon(Icons.mail));
      await tester.pumpAndSettle();
        expect(find.byType(LandingPageInvitationTile), findsOneWidget);

      // Tap on Icons.settings to go to Settings tab
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Tap on Icons.local_florist to go to ListedGardenTiles
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      // Tap on LandingPageListedGardenTile
      await tester.tap(find.byType(LandingPageListedGardenTile));
      await tester.pumpAndSettle();

      // Tap on TileExamineAskButton
      await tester.tap(find.byType(TileExamineAskButton).first);
      await tester.pumpAndSettle();

      // Close Dialog
      await tester.ensureVisible(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();

      // Open CreateAskView
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Tap Icons.toc_rounded to go to ListedAsksView
      await tester.ensureVisible(find.byIcon(Icons.toc_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.toc_rounded));
      await tester.pumpAndSettle();

      // Tap Icons.volunteer_activism to go to SponsoredAsksView
      await tester.ensureVisible(find.byIcon(Icons.volunteer_activism));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.volunteer_activism));
      await tester.pumpAndSettle();

      // Navigate to CurrentGardenSettingsView (first NavButton is on the left)
      await tester.ensureVisible(find.byType(AppDialogFooterNavButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppDialogFooterNavButton).first);
      await tester.pumpAndSettle();

      // Navigate to UserSettingsList (first NavButton is on the left)
      await tester.ensureVisible(find.byType(AppDialogFooterNavButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppDialogFooterNavButton).first);
      await tester.pumpAndSettle();

      // Log out
      await tester.ensureVisible(find.byType(LogOutButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(LogOutButton));
      await tester.pumpAndSettle();
    });

    testWidgets("owner login_logout", (tester) async {
      final now = DateTime.now();

      // Users
      final user = AppUserFactory();
      final otherUser = AppUserFactory();

      // User Settings
      final userSettings = AppUserSettingsFactory(user: user);

      // Gardens
      final garden = GardenFactory();
      final otherGarden = GardenFactory();

      // User Garden Records
      final userGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        role: AppUserGardenRole.owner,
        user: user,
      );
      final otherUserGardenRecord = AppUserGardenRecordFactory(
        garden: garden,
        role: AppUserGardenRole.member,
        user: otherUser,
      );

      // Asks
      final ask = AskFactory(
        creator: user,
        deadlineDate: now.add(const Duration(days: 2))
      );
      final otherAsk = AskFactory(creator: otherUser,);

      // Invitations
      final privateInvitation = InvitationFactory(
        invitee: user,
        garden: otherGarden,
        type: InvitationType.private
      );

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.authStore
      final authStore = AuthStore();

      appTestSetupStub(
        ask: ask,
        authStore: authStore,
        garden: garden,
        otherAsk: otherAsk,
        otherGarden: otherGarden,
        otherUser: otherUser,
        otherUserGardenRecord: otherUserGardenRecord,
        pb: pb,
        privateInvitation: privateInvitation,
        recordService: recordService,
        user: user,
        userGardenRecord: userGardenRecord,
        userSettings: userSettings);


      await tester.pumpWidget(MyApp(database: pb));

      // Enter username and password
      await tester.enterText(find.byType(AppTextFormField), user.username);
      await tester.enterText(find.byType(LogInPasswordFormField), "testuserpassword");

      // Tap on Log In button
      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      // Tap on Icons.mail to go to Invitations Tab
      await tester.tap(find.byIcon(Icons.mail));
      await tester.pumpAndSettle();
      expect(find.byType(LandingPageInvitationTile), findsOneWidget);

      // Tap on Icons.settings to go to Settings Tab
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Tap on Icons.local_florist to go to Gardens Tab
      await tester.tap(find.byIcon(Icons.local_florist));
      await tester.pumpAndSettle();

      // Tap on LandingPageListedGardenTile to go to Garden page
      await tester.tap(find.byType(LandingPageListedGardenTile));
      await tester.pumpAndSettle();

      // Tap on TileExamineAskButton to examine otherUser Ask
      await tester.tap(find.byType(TileExamineAskButton).first);
      await tester.pumpAndSettle();

      // Close ExamineAskView Dialog
      await tester.ensureVisible(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();

      // Open CreateAskView Dialog
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Tap Icons.toc_rounded to go to ListedAsksView
      await tester.ensureVisible(find.byIcon(Icons.toc_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.toc_rounded));
      await tester.pumpAndSettle();

      // Tap Icons.volunteer_activism to go to SponsoredAsksView
      await tester.ensureVisible(find.byIcon(Icons.volunteer_activism));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.volunteer_activism));
      await tester.pumpAndSettle();

      // Navigate to CurrentGardenSettingsView (first NavButton is on the left)
      await tester.ensureVisible(find.byType(AppDialogFooterNavButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppDialogFooterNavButton).first);
      await tester.pumpAndSettle();

      // Tap on goToAdminPageLabel to go to Admin page
      await tester.ensureVisible(find.text(GardenSettingsViewText.goToAdminPageLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text(GardenSettingsViewText.goToAdminPageLabel));
      await tester.pumpAndSettle();

      // Open AdminOptionsView (use last, because there is another Icons.security in the GardenHeader)
      await tester.ensureVisible(find.byIcon(Icons.security).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.security).last);
      await tester.pumpAndSettle();

      // Tap on Icons.mail to go to AdminCreateInvitationView
      await tester.ensureVisible(find.byIcon(Icons.mail));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.mail));
      await tester.pumpAndSettle();

      // Tap on Icons.outbox to go to AdminListedInvitationsView
      await tester.ensureVisible(find.byIcon(Icons.outbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.outbox));
      await tester.pumpAndSettle();

      // Tap on Icons.arrow_back to return to AdminOptionsView
      await tester.ensureVisible(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to AdminListedUsersView (last NavButton is on the right)
      await tester.ensureVisible(find.byType(AppDialogFooterNavButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppDialogFooterNavButton).last);
      await tester.pumpAndSettle();

      // Tap on AdminListedUserTile of otherUser, to go to AdminEditUserView
      await tester.ensureVisible(find.text(otherUser.username));
      await tester.pumpAndSettle();
      await tester.tap(find.text(otherUser.username));
      await tester.pumpAndSettle();

      // Tap on Icons.arrow_back to return to AdminListedUsersView
      await tester.ensureVisible(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to AdminCurrentGardenSettingsView (last NavButton is on the right)
      await tester.ensureVisible(find.byType(AppDialogFooterNavButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppDialogFooterNavButton).last);
      await tester.pumpAndSettle();

      // Tap on Icons.local_florist to return to Garden page
      await tester.ensureVisible(find.text(AdminCurrentGardenSettingsViewText.returnToGardenPage));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AdminCurrentGardenSettingsViewText.returnToGardenPage));
      await tester.pumpAndSettle();

      // Open CreateAskView again
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Navigate to UserSettingsList (last NavButton is on the right)
      await tester.ensureVisible(find.byType(AppDialogFooterNavButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppDialogFooterNavButton).last);
      await tester.pumpAndSettle();

      // Log out
      await tester.ensureVisible(find.byType(LogOutButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(LogOutButton));
      await tester.pumpAndSettle();
    });
  });

}