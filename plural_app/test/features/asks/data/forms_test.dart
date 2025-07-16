import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/data/forms.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("Ask submitCreate", () {
    ft.testWidgets("valid create", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true)
                      ..setValue(fieldName: fieldName, value: null);
      final appState = AppState.skipSubscribe()
                      ..currentGarden = tc.garden // for getAsksByUserID
                      ..currentUser = tc.user;

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.create()
      when(
        () => mockAsksRepository.create(body: appForm.fields)
      ).thenAnswer(
        (_) async => (tc.getAskRecordModel(), {})
      );

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
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
                          fieldName: fieldName,
                          value: "New Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitCreate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved; check testList has values
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAsksRepository.create(body: appForm.fields));
      verifyNever(() => mockAsksRepository.getList(
        filter: any(named: "filter"), sort: any(named: "sort"))
      );
      verifyNever(() => mockUsersRepository.getFirstListItem(
        filter: any(named: "filter"))
      );
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Value!");

      // Check methods were called; check expected values are found
      verify(() => mockAsksRepository.create(body: appForm.fields)).called(1);
      verify(() => mockAsksRepository.getList(
        filter: any(named: "filter"), sort: any(named: "sort"))
      ).called(1);
      verify(() => mockUsersRepository.getFirstListItem(
        filter: any(named: "filter"))
      ).called(1);
      expect(formKey.currentState!.validate(), true);
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);

      // Check testList still has values (no error)
      expect(testList.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid create", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "fields";
      final appForm = AppForm()
                      ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true)
                      ..setValue(fieldName: fieldName, value: null);
      final appState = AppState()
                      ..currentUser = tc.user;

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockAppDialogViewRouter = MockAppDialogViewRouter();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);

      // AsksRepository.create()
      when(
        () => mockAsksRepository.create(body: appForm.fields)
      ).thenAnswer(
        (_) async => (null, {"field1": "Error for field1"})
      );

      // AppDialogViewRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogViewRouter.routeToListedAsksView()
      ).thenAnswer(
        (_) async => {}
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
                          fieldName: fieldName,
                          value: "New Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitCreate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm has not saved and has no error; check testList has values
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(appForm.getError(fieldName: "field1"), null);
      expect(testList.isEmpty, false);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAsksRepository.create(body: appForm.fields));
      verifyNever(() => mockAppDialogViewRouter.routeToListedAsksView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Value!");

      // Check methods were called; check expected values are found
      expect(formKey.currentState!.validate(), true);
      verify(() => mockAsksRepository.create(body: appForm.fields)).called(1);

      // Check error added to appForm; check testList is empty (error was found)
      expect(appForm.getError(fieldName: "field1"), "Error for field1");
      expect(testList.isEmpty, true);

      // Check still no snackbar; router never called
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      verifyNever(() => mockAppDialogViewRouter.routeToListedAsksView());
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final appForm = AppForm()
                      ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true);
      final appState = AppState()
                      ..currentUser = tc.user;

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockAppDialogViewRouter = MockAppDialogViewRouter();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AsksRepository.create()
      when(
        () => mockAsksRepository.create(body: appForm.fields)
      ).thenAnswer(
        (_) async => (null, {"field1": "Error for field1"})
      );

      // AsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort")
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(items: [tc.getAskRecordModel()])
      );

      // UsersRepository.getFirstListItem()
      when(
        () => mockUsersRepository.getFirstListItem(filter: any(named: "filter"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // AppDialogViewRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogViewRouter.routeToListedAsksView()
      ).thenAnswer(
        (_) async => {}
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
                        validator: (value) => "error!!",
                      ),
                      ElevatedButton(
                        onPressed: () => submitCreate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm has no error; testList has values
      expect(appForm.getError(fieldName: "field1"), null);
      expect(testList.isEmpty, false);

      // Check no methods called before submit; no snackbar
      verifyNever(() => mockAsksRepository.create(body: appForm.fields));
      verifyNever(() => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort"))
      );
      verifyNever(() => mockUsersRepository.getFirstListItem(
        filter: any(named: "filter"))
      );
      verifyNever(() => mockAppDialogViewRouter.routeToListedAsksView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Form should not have been valid
      expect(formKey.currentState!.validate(), false);

      // Check still no method called
      verifyNever(() => mockAsksRepository.create(body: appForm.fields));
      verifyNever(() => mockAsksRepository.getList(
          filter: any(named: "filter"), sort: any(named: "sort"))
      );
      verifyNever(() => mockUsersRepository.getFirstListItem(
        filter: any(named: "filter"))
      );

      // Check no error added to appForm; check testList still has values
      expect(appForm.getError(fieldName: "field1"), null);
      expect(testList.isEmpty, false);

      // Check still no snackbar; router never called
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      verifyNever(() => mockAppDialogViewRouter.routeToListedAsksView());
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("Ask submitUpdate", () {
    ft.testWidgets("valid update", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: GenericField.id, value: "ID")
                      ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true)
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: "ID",
          body: appForm.fields
        )
      ).thenAnswer(
        (_) async => (tc.getAskRecordModel(), {})
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
                          fieldName: fieldName,
                          value: "Updated Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved; check testList has values
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAsksRepository.update(
        id: "ID",
        body: appForm.fields
      ));

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "Updated Value!");

      // Check methods were called
      // NOTE: cannot check on formKey.currentState or Snackbar due to inner Navigator.pop()
      verify(() => mockAsksRepository.update(
        id: "ID",
        body: appForm.fields
      )).called(1);

      // Check testList still has values (no error)
      expect(testList.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid update", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: GenericField.id, value: "ID")
                      ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true)
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: "ID",
          body: appForm.fields
        )
      ).thenAnswer(
        (_) async => (null, {"field2": "Error for field2"})
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
                          fieldName: fieldName,
                          value: "Updated Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved; check testList has values
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(testList.isEmpty, false);

      // Check no method calls before submit
      verifyNever(() => mockAsksRepository.update(
        id: "ID",
        body: appForm.fields
      ));

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is valid
      expect(formKey.currentState!.validate(), true);

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "Updated Value!");

      // Check methods were called
      // NOTE: cannot check on formKey.currentState due to inner Navigator.pop()
      verify(() => mockAsksRepository.update(
        id: "ID",
        body: appForm.fields
      )).called(1);

      // Check error added to appForm; check testList is empty (error)
      expect(appForm.getError(fieldName: "field2"), "Error for field2");
      expect(testList.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: GenericField.id, value: "ID")
                      ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true)
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(
          id: "ID",
          body: appForm.fields
        )
      ).thenAnswer(
        (_) async => (tc.getAskRecordModel(), {})
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
                          fieldName: fieldName,
                          value: "Updated Value!",
                        ),
                        validator: (value) => "error!",
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved; check testList has values
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit
      verifyNever(() => mockAsksRepository.update(
        id: "ID",
        body: appForm.fields
      ));

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is invalid
      expect(formKey.currentState!.validate(), false);

      // Check appForm has not saved new value
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check methods never called
      verifyNever(() => mockAsksRepository.update(
        id: "ID",
        body: appForm.fields
      ));

      // Check no error added to appForm; check testList is not empty (method not called)
      expect(appForm.getError(fieldName: "field2"), null);
      expect(testList.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());
  });
}