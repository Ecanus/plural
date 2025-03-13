import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import "package:mocktail/mocktail.dart";
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/data/forms.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
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
                              ..setValue(fieldName: AppFormFields.rebuild, value: func);
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      final appState = AppState()
                      ..currentUser = tc.user;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogRouter.routeToAskDialogListView()
      ).thenAnswer(
        (_) async => {}
      );

      // AsksRepository.create()
      when(
        () => mockAsksRepository.create(appForm.fields)
      ).thenAnswer(
        (_) async => (true, {})
      );

      // AsksRepository.getAsksByUserID()
      when(
        () => mockAsksRepository.getAsksByUserID(userID: tc.user.id)
      ).thenAnswer(
        (_) async => [tc.ask]
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
      verifyNever(() => mockAsksRepository.create(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToAskDialogListView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Value!");

      // Check methods were called; check expected values are found
      verify(() => mockAsksRepository.create(appForm.fields)).called(1);
      verify(() => mockAppDialogRouter.routeToAskDialogListView()).called(1);
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
                              ..setValue(fieldName: AppFormFields.rebuild, value: func);
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      final appState = AppState()
                      ..currentUser = tc.user;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogRouter.routeToAskDialogListView()
      ).thenAnswer(
        (_) async => {}
      );

      // AsksRepository.create()
      when(
        () => mockAsksRepository.create(appForm.fields)
      ).thenAnswer(
        (_) async => (false, {"field1": "Error for field1"})
      );

      // AsksRepository.getAsksByUserID()
      when(
        () => mockAsksRepository.getAsksByUserID(userID: tc.user.id)
      ).thenAnswer(
        (_) async => [tc.ask]
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
      verifyNever(() => mockAsksRepository.create(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToAskDialogListView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Value!");

      // Check methods were called; check expected values are found
      expect(formKey.currentState!.validate(), true);
      verify(() => mockAsksRepository.create(appForm.fields)).called(1);

      // Check error added to appForm; check testList is empty (error was found)
      expect(appForm.getError(fieldName: "field1"), "Error for field1");
      expect(testList.isEmpty, true);

      // Check still no snackbar; router never called
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      verifyNever(() => mockAppDialogRouter.routeToAskDialogListView());
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final appForm = AppForm()
                              ..setValue(fieldName: AppFormFields.rebuild, value: func);
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      final appState = AppState()
                      ..currentUser = tc.user;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToAskDialogListView()
      when(
        () => mockAppDialogRouter.routeToAskDialogListView()
      ).thenAnswer(
        (_) async => {}
      );

      // AsksRepository.create()
      when(
        () => mockAsksRepository.create(appForm.fields)
      ).thenAnswer(
        (_) async => (false, {"field1": "Error for field1"})
      );

      // AsksRepository.getAsksByUserID()
      when(
        () => mockAsksRepository.getAsksByUserID(userID: tc.user.id)
      ).thenAnswer(
        (_) async => [tc.ask]
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
      verifyNever(() => mockAsksRepository.create(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToAskDialogListView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Form should not have been valid
      expect(formKey.currentState!.validate(), false);

      // Check still no method called
      verifyNever(() => mockAsksRepository.create(appForm.fields));

      // Check no error added to appForm; check testList still has values
      expect(appForm.getError(fieldName: "field1"), null);
      expect(testList.isEmpty, false);

      // Check still no snackbar; router never called
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      verifyNever(() => mockAppDialogRouter.routeToAskDialogListView());
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("Ask submitUpdate", () {
    ft.testWidgets("valid update", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                              ..setValue(fieldName: AppFormFields.rebuild, value: func);
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(appForm.fields)
      ).thenAnswer(
        (_) async => (true, {})
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
      verifyNever(() => mockAsksRepository.update(appForm.fields));

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "Updated Value!");

      // Check methods were called
      // NOTE: cannot check on formKey.currentState or Snackbar due to inner Navigator.pop()
      verify(() => mockAsksRepository.update(appForm.fields)).called(1);

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
                              ..setValue(fieldName: AppFormFields.rebuild, value: func);
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(appForm.fields)
      ).thenAnswer(
        (_) async => (false, {"field2": "Error for field2"})
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
      verifyNever(() => mockAsksRepository.update(appForm.fields));

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is valid
      expect(formKey.currentState!.validate(), true);

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "Updated Value!");

      // Check methods were called
      // NOTE: cannot check on formKey.currentState due to inner Navigator.pop()
      verify(() => mockAsksRepository.update(appForm.fields)).called(1);

      // Check error added to appForm; check testList is empty (error)
      expect(appForm.getError(fieldName: "field2"), "Error for field2");
      expect(testList.isEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                              ..setValue(fieldName: AppFormFields.rebuild, value: func);
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.update()
      when(
        () => mockAsksRepository.update(appForm.fields)
      ).thenAnswer(
        (_) async => (true, {})
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
      verifyNever(() => mockAsksRepository.update(appForm.fields));

      // Tap ElevatedButton (to call submitUpdate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is invalid
      expect(formKey.currentState!.validate(), false);

      // Check appForm has not saved new value
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check methods never called
      verifyNever(() => mockAsksRepository.update(appForm.fields));

      // Check error added to appForm; check testList is empty (error)
      expect(appForm.getError(fieldName: "field2"), null);
      expect(testList.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("Ask submitDelete", () {
    ft.testWidgets("valid delete", (tester) async {
      // AppForm
      const fieldName = "champs";
      final appForm = AppForm();
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.delete()
      when(
        () => mockAsksRepository.delete(appForm.fields)
      ).thenAnswer(
        (_) async => (true, {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ListView(
                  children: [
                    TextFormField(
                      onSaved: (value) => appForm.save(
                        fieldName: fieldName,
                        value: "My Value!",
                      ),
                      validator: (value) => null,
                    ),
                    ElevatedButton(
                      onPressed: () => submitDelete(context, appForm),
                      child: Text("x")
                    ),
                  ],
                );
              })
          ),
        )
      );

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAsksRepository.delete(appForm.fields));

      // Tap ElevatedButton (to call submitDelete)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods were called
      // NOTE: Can't check Snackbar due to inner Navigator.pop()
      verify(() => mockAsksRepository.delete(appForm.fields)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid delete", (tester) async {
      // AppForm
      const fieldName = "champs";
      final appForm = AppForm();
      appForm.setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AsksRepository.delete()
      when(
        () => mockAsksRepository.delete(appForm.fields)
      ).thenAnswer(
        (_) async => (false, {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ListView(
                  children: [
                    TextFormField(
                      onSaved: (value) => appForm.save(
                        fieldName: fieldName,
                        value: "My Value!",
                      ),
                      validator: (value) => null,
                    ),
                    ElevatedButton(
                      onPressed: () => submitDelete(context, appForm),
                      child: Text("x")
                    ),
                  ],
                );
              })
          ),
        )
      );

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAsksRepository.delete(appForm.fields));

      // Tap ElevatedButton (to call submitDelete)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods were called
      // NOTE: Can't check Snackbar due to inner Navigator.pop()
      verify(() => mockAsksRepository.delete(appForm.fields)).called(1);
    });

    tearDown(() => GetIt.instance.reset());
  });
}