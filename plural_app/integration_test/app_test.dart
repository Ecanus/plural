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

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_timeline_tile.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/route_to_view_button.dart';

// Tests
import '../test/test_factories.dart';
import '../test/test_mocks.dart';
import '../test/test_record_models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets("login to logout", (tester) async {
      final now = DateTime.now();

      final user = AppUserFactory();
      final garden = GardenFactory();
      final userSettings = AppUserSettingsFactory(user: user);
      final ask = AskFactory(
        creator: user,
        deadlineDate: now.add(const Duration(days: 2))
      );

      final otherUser = AppUserFactory();
      final otherAsk = AskFactory(
        id: "THEOTHERASK",
        boon: 45,
        creator: otherUser,
        creationDate: now.add(const Duration(days: -5)),
        currency: "KRW",
        deadlineDate: now.add(const Duration(days: 50)),
        description: "This ask belongs to another user. Not the one logged in.",
        instructions: "Get everybody and the stuff together.",
        targetSum: 1350,
      );

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.authStore
      var authStore = AuthStore();
      authStore.save("newToken", getUserRecordModel(user: user));
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
        () => recordService.getFirstListItem("${GenericField.id} = '${user.id}'")
      ).thenAnswer(
        (_) async => getUserRecordModel(user: user)
      );
      // RecordService.getFirstListItem() - otherUser
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${otherUser.id}'")
      ).thenAnswer(
        (_) async => getUserRecordModel(user: otherUser)
      );
      // RecordService.getFirstListItem() - garden.creator
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${garden.creator.id}'")
      ).thenAnswer(
        (_) async => getUserRecordModel(user: garden.creator)
      );
      // RecordService.getFirstListItem() - userSettings
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${user.id}'")
      ).thenAnswer(
        (_) async => getUserSettingsRecordModel(userSettings: userSettings)
      );
      // RecordService.getFirstListItem() - garden
      when(
        () => recordService.getFirstListItem(
          "${GenericField.id} = '${garden.id}'")
      ).thenAnswer(
        (_) async => getGardenRecordModel(garden: garden)
      );

      // RecordService.getList() - getUserGardenRecordsByUserID()
      when(
        () => recordService.getList(
          expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
          filter: "${UserGardenRecordField.user} = '${user.id}'",
          sort: "${UserGardenRecordField.garden}.${GardenField.name}",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              garden: garden,
              user: user,
            ),
            expandFields: [
              UserGardenRecordField.user,
              UserGardenRecordField.garden
          ])]
        )
      );
      // RecordService.getList() - getUserGardenRecord()
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: ""
            "${UserGardenRecordField.user} = '${user.id}' && "
            "${UserGardenRecordField.garden} = '${garden.id}'",
          sort: "-updated",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: AppUserGardenRecordFactory(
                garden: garden,
                role: AppUserGardenRole.owner,
                user: user,
              ),
              expandFields: [
                UserGardenRecordField.user,
                UserGardenRecordField.garden
              ],
            ),
          ]
        )
      );
      // RecordService.getList() - getGardensByUser(excludeCurrentGarden: false)
      when(
        () => recordService.getList(
          expand: UserGardenRecordField.garden,
          filter: "${UserGardenRecordField.user} = '${user.id}'",
          sort: "garden.name",
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            getUserGardenRecordRecordModel(
              userGardenRecord: AppUserGardenRecordFactory(
                garden: garden,
                user: user,
              ),
              expandFields: [UserGardenRecordField.garden]
          )]
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
            getAskRecordModel(ask: ask),
            getAskRecordModel(ask: otherAsk)
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
        (_) async => ResultList<RecordModel>(items: [getAskRecordModel(ask: ask)]
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
      await tester.enterText(find.byType(AppTextFormField), user.username);
      await tester.enterText(find.byType(LogInPasswordFormField), "testuserpassword");

      // Tap on Log In button
      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 10));

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

      // Tap first RouteToButton to go to ListedAsksView
      await tester.ensureVisible(find.byType(RouteToViewButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RouteToViewButton).first);
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