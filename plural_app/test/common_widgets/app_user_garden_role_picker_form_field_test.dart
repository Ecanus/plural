import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_user_garden_role_picker_form_field.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Test
import '../test_factories.dart';
import '../tester_functions.dart';

void main() {
  group("AppUserGardenRolePickerFormField test", () {
    testWidgets("initial values", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = UserGardenRecordField.role;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppUserGardenRolePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: AppUserGardenRole.member.displayName,
            )
          ),
        )
      );

      // Check text is the display name of the corresponding enum
      expect(
        textFieldController(tester).value.text,
        AppUserGardenRole.member.displayName
      );

    });

    testWidgets("onSaved", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = UserGardenRecordField.role;
      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppUserGardenRolePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: AppUserGardenRole.member.displayName,
              ),
            )
          ),
        )
      );

      // Check appForm value null at first
      expect(appForm.getValue(fieldName: fieldName), null);

      // Set text to a value
      textFieldController(tester).text = AppUserGardenRole.administrator.displayName;
      formKey.currentState!.save();

      // Check value saved to appForm (should be .name, not .displayName)
      expect(
        appForm.getValue(fieldName: fieldName),
        AppUserGardenRole.administrator.name
      );
    });

    testWidgets("invalid value", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = UserGardenRecordField.role;
      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppUserGardenRolePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: AppUserGardenRole.member.displayName,
              ),
            )
          ),
        )
      );

      // appForm value is null; no error message is shown
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to invalid value; validate be false
      textFieldController(tester).text = "???";
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Value not saved to appForm; error text now shown
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsOneWidget);
    });

    testWidgets("showRolePickerDialog select value", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory(creator: user);
      final userGardenRecord = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
        role: AppUserGardenRole.administrator);

      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = UserGardenRecordField.role;
      appForm.setValue(fieldName: fieldName, value: null);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppUserGardenRolePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: AppUserGardenRole.member.displayName,
              ),
            )
          ),
        )
      );

      // Text is "Member" at first
      expect(
        textFieldController(tester).value.text,
        AppUserGardenRole.member.displayName
      );

      // Open Dialog
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // Tap on "Administrator"
      await tester.tap(find.text(AppUserGardenRole.administrator.displayName));
      await tester.pumpAndSettle();

      // Check "Administrator" string set; dialog closed
      expect(
        textFieldController(tester).value.text,
        AppUserGardenRole.administrator.displayName
      );
      expect(find.byType(Dialog), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("getUserGardenRoleCards", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory(creator: user);

      final userGardenRecordOwner = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
        role: AppUserGardenRole.owner
      );
      final userGardenRecordAdmin = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
        role: AppUserGardenRole.administrator
      );
      final userGardenRecordMember = AppUserGardenRecordFactory(
        user: user,
        garden: garden,
        role: AppUserGardenRole.member
      );

      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = UserGardenRecordField.role;
      appForm.setValue(fieldName: fieldName, value: null);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecordOwner
        ..currentUser = user;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppUserGardenRolePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: AppUserGardenRole.member.displayName,
              ),
            )
          ),
        )
      );

      // Open Dialog
      await tester.tap(find.byIcon(Icons.mode_edit_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // For user is Owner, 3 cards: "Owner", "Administrator" and "Member" show
      expect(find.byType(UserGardenRoleCard), findsNWidgets(3));

      // Close the dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Set AppState.currentUserGardenRecord to be an admin now
      appState.currentUserGardenRecord = userGardenRecordAdmin;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppUserGardenRolePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: AppUserGardenRole.member.displayName,
              ),
            )
          ),
        )
      );

      // Open Dialog
      await tester.tap(find.byIcon(Icons.mode_edit_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // For user is Administrator, 2 cards: "Administrator" and "Member" show
      expect(find.byType(UserGardenRoleCard), findsNWidgets(2));

      // Close the dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Set AppState.currentUserGardenRecord to be a member now
      appState.currentUserGardenRecord = userGardenRecordMember;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppUserGardenRolePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: AppUserGardenRole.member.displayName,
              ),
            )
          ),
        )
      );

      // Open Dialog
      await tester.tap(find.byIcon(Icons.mode_edit_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // For user is Member, 0 cards
      expect(find.byType(UserGardenRoleCard), findsNothing);

      // Close the dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
    });

    tearDown(() => GetIt.instance.reset());
  });
}