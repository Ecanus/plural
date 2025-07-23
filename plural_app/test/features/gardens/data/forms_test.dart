import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/forms.dart';
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Test
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_stubs.dart';

void main() {
  group("gardens forms submitUpdate", () {
    ft.testWidgets("valid", (tester) async {
      final testList = [1, 2, 3];
      void testFunc() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      final appForm = AppForm()
        ..setValue(
            fieldName: GenericField.id, value: tc.garden.id)
        ..setValue(
            fieldName: GardenField.creator, value: tc.user.id)
        ..setValue(
            fieldName: GardenField.name, value: "NewGardenName")
        ..setValue(
            fieldName: AppFormFields.rebuild, value: testFunc, isAux: true);

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // Stubs
      final items = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: items
      );
      gardensRepositoryUpdateStub(
        mockGardensRepository: mockGardensRepository,
        gardenID: tc.garden.id,
        gardenName: appForm.getValue(fieldName: GardenField.name),
        returnValue: (tc.getGardenRecordModel(), {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        onSaved: (value) => appForm.save(
                          fieldName: "testField",
                          value: "New Random Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdate(
                          context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

       // check no snackBar, testList still has contents
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(testList.isEmpty, false);

      // Tap ElevatedButton (to call submitUpdateUserGardenRecord)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // check snackBar now appears; testList still has contents
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);
      expect(testList.isEmpty, false);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid", (tester) async {
      final testList = [1, 2, 3];
      void testFunc() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      final appForm = AppForm()
        ..setValue(
            fieldName: GenericField.id, value: tc.garden.id)
        ..setValue(
            fieldName: GardenField.creator, value: tc.user.id)
        ..setValue(
            fieldName: GardenField.name, value: "NewGardenName")
        ..setValue(
            fieldName: AppFormFields.rebuild, value: testFunc, isAux: true);

      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden
                      ..currentUser = tc.user;

      final getIt = GetIt.instance;
      final mockGardensRepository = MockGardensRepository();
      final mockUserGardenRecordsRepository = MockUserGardenRecordsRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<GardensRepository>(() => mockGardensRepository);
      getIt.registerLazySingleton<UserGardenRecordsRepository>(
        () => mockUserGardenRecordsRepository
      );

      // Stubs
      final items = ResultList<RecordModel>(items: [
        tc.getUserGardenRecordRecordModel(role: AppUserGardenRole.administrator)
      ]);
      getUserGardenRecordRoleStub(
        mockUserGardenRecordsRepository: mockUserGardenRecordsRepository,
        userID: tc.user.id,
        gardenID: tc.garden.id,
        returnValue: items
      );
      gardensRepositoryUpdateStub(
        mockGardensRepository: mockGardensRepository,
        gardenID: tc.garden.id,
        gardenName: appForm.getValue(fieldName: GardenField.name),
        returnValue: (null, {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        onSaved: (value) => appForm.save(
                          fieldName: "testField",
                          value: "New Random Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdate(
                          context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

       // check no snackBar, testList still has contents
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(testList.isEmpty, false);

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check no snackBar; testList is now empty (rebuild() method was called)
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(testList.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());
  });
}