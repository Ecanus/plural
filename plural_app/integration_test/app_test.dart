import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Plural
import 'package:plural_app/src/app.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer_nav_button.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/route_to_listed_asks_view_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_listed_garden_tile.dart';

// Tests
import '../test/test_context.dart';
import '../test/test_mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets("login to logout", (tester) async {
      final now = DateTime.now();
      final tc = TestContext();

      tc.ask.deadlineDate = now.add(const Duration(days: 2));

      final otherUser = AppUser(
        email: "otheruser@test.com",
        firstName: "OtherFirst",
        id: "OTHERUSER",
        lastName: "OtherLast",
        username: "theotheruser"
      );

      final otherAsk = Ask(
        id: "THEOTHERASK",
        boon: 45,
        creator: otherUser,
        creationDate: now.add(const Duration(days: -5)),
        currency: "KRW",
        deadlineDate: now.add(const Duration(days: 50)),
        description: "This ask belongs to another user. Not the one logged in.",
        instructions: "Get everybody and the stuff together.",
        targetSum: 1350,
        type: AskType.monetary
      );

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.authStore
      var authStore = AuthStore();
      authStore.save("newToken", tc.getUserRecordModel());
      when(
        () => pb.authStore
      ).thenReturn(
        authStore
      );

      // pb.collection()
      when(
        () => pb.collection(Collection.asks)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.gardens)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userGardenRecords)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.authWithPassword()
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenAnswer(
        (_) async => RecordAuth()
      );

      // RecordService.getFirstListItem() - user
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      // RecordService.getFirstListItem() - otherUser
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${otherUser.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel(
          id: otherUser.id,
          email: otherUser.email,
          username: otherUser.username,
        )
      );
      // RecordService.getFirstListItem() - userSettings
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );
      // RecordService.getFirstListItem() - garden
      when(
        () => recordService.getFirstListItem(
          "${GenericField.id} = '${tc.garden.id}'")
      ).thenAnswer(
        (_) async => tc.getGardenRecordModel()
      );

      // RecordService.getList() - getGardensByUser(excludeCurrentGarden: true)
      when(
        () => recordService.getList(
          expand: UserGardenRecordField.garden,
          filter: ""
            "${UserGardenRecordField.garden}.${GenericField.id} != '${tc.garden.id}' && "
            "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: "garden.name",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden)]
        )
      );
      // RecordService.getList() - getUserGardenRecord()
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: ""
            "${UserGardenRecordField.user} = '${tc.user.id}' && "
            "${UserGardenRecordField.garden} = '${tc.garden.id}'",
          sort: "-updated",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getUserGardenRecordRecordModel()]
        )
      );
      // RecordService.getList() - getGardensByUser(excludeCurrentGarden: false)
      when(
        () => recordService.getList(
          expand: UserGardenRecordField.garden,
          filter: "${UserGardenRecordField.user} = '${tc.user.id}'",
          sort: "garden.name",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [tc.getExpandUserGardenRecordRecordModel(UserGardenRecordField.garden)]
        )
      );
      // RecordService.getList() - getAsksByGardenID
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"), // use any() because internal nowString is down to the second (inconsistent to recreate)
          sort: "${AskField.deadlineDate},${GenericField.created}",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getAskRecordModel(),
            tc.getAskRecordModel(
              id: otherAsk.id,
              creationDate: otherAsk.creationDate,
              creatorID: otherAsk.creator.id,
              deadlineDate: otherAsk.deadlineDate,
              description: otherAsk.description,
              instructions: otherAsk.instructions,
              targetSum: otherAsk.targetSum,
            )
          ]
        )
      );
      // recordService.getList() - getAsksForListedAsksDialog()
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"), // Use any(). Copy pasting the filter string doesn't seem to work
          sort: GenericField.created,
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()]
        )
      );

      // RecordService.unsubscribe()
      when(
        () => recordService.unsubscribe()
      ).thenAnswer(
        (_) async => () async {}
      );

      // RecordService.subscribe()
      when(
        () => recordService.subscribe(any(), any())
      ).thenAnswer(
        (_) async => () async {}
      );

      await tester.pumpWidget(MyApp(database: pb));

      // Enter username and password
      await tester.enterText(find.byType(AppTextFormField), tc.user.username);
      await tester.enterText(find.byType(LogInPasswordFormField), "testuserpassword");

      // Tap on Log In button
      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      // Tap on LandingPageListedGardenTile
      await tester.tap(find.byType(LandingPageListedGardenTile));
      await tester.pumpAndSettle();

      // Tap on TileViewAskButton
      await tester.tap(find.byType(TileViewAskButton));
      await tester.pumpAndSettle();

      // Close Dialog
      await tester.ensureVisible(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();

      // Tap on TileEditAskButton
      await tester.tap(find.byType(TileEditAskButton));
      await tester.pumpAndSettle();

      // Close Dialog
      await tester.ensureVisible(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();

      // Open CreatableAskDialog
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Tap RouteToListedAsksViewButton
      await tester.ensureVisible(find.byType(RouteToListedAsksViewButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToListedAsksViewButton));
      await tester.pumpAndSettle();

      // Navigate to GardenDialogList (first NavButton is on the left)
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
  });

}