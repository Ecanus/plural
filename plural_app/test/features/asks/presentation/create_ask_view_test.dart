import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/create_ask_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("CreateAskView", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory(id: "test_user_1");
      final garden = GardenFactory(creator: user);
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings;

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      final userGardenRecordReturnValue = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              user: user,
              garden: garden
            ),
            expandFields: [
              UserGardenRecordField.user, UserGardenRecordField.garden
            ]),
        ]
      );
      getUserGardenRecordStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        userGardenRecordReturnValue: userGardenRecordReturnValue,
        mockUsersRepository: mockUsersRepository,
        gardenCreatorID: user.id,
        gardenCreatorReturnValue: getUserRecordModel(user: user)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createCreateAskDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.byType(CreateAskHeader), findsNothing);
      expect(find.byType(AppDatePickerFormField), findsNothing);
      expect(find.byType(AppTextFormField), findsNothing);
      expect(find.byType(AppCurrencyPickerFormField), findsNothing);
      expect(find.byType(AppDialogFooterBufferSubmitButton), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsNothing);
      expect(find.byType(AppDialogNavFooter), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(CreateAskHeader), findsOneWidget);
      expect(find.byType(AppDatePickerFormField), findsOneWidget);
      expect(find.byType(AppTextFormField), findsNWidgets(5));
      expect(find.byType(AppCurrencyPickerFormField), findsOneWidget);
      expect(find.byType(AppDialogFooterBufferSubmitButton), findsOneWidget);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("CreateAskHeader", (tester) async {
      final editDate = DateTime(2000, 1, 31);

      final user = AppUserFactory(id: "test_user_1");
      final garden = GardenFactory(
        creator: user,
        doDocumentEditDate: editDate,
      );
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState.skipSubscribe()
        ..currentGarden = garden
        ..currentUser = user
        ..currentUserSettings = userSettings;

      // GetIt
      final getIt = GetIt.instance;
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // UserGardenRecordsRepository.getList()
      final userGardenRecordReturnValue = ResultList<RecordModel>(
        items: [
          getUserGardenRecordRecordModel(
            userGardenRecord: AppUserGardenRecordFactory(
              user: user,
              garden: garden,
              doDocumentReadDate: editDate.add(Duration(days: -2))
            ),
            expandFields: [
              UserGardenRecordField.user, UserGardenRecordField.garden
            ]),
        ]
      );
      getUserGardenRecordStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: user.id,
        gardenID: garden.id,
        userGardenRecordReturnValue: userGardenRecordReturnValue,
        mockUsersRepository: mockUsersRepository,
        gardenCreatorID: user.id,
        gardenCreatorReturnValue: getUserRecordModel(user: user)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createCreateAskDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check expected values are found
      expect(find.text(AskViewText.readDoDocumentStart), findsNothing);
      expect(find.text(AskViewText.doDocument), findsNothing);
      expect(find.text(AskViewText.readDoDocumentEnd), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.text(AskViewText.readDoDocumentStart), findsOneWidget);
      expect(find.text(AskViewText.doDocument), findsOneWidget);
      expect(find.text(AskViewText.readDoDocumentEnd), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}