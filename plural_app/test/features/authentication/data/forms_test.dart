import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import 'package:plural_app/src/features/authentication/data/forms.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_form.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';
import '../../../test_widgets.dart';

void main() {
  group("Auth submitUpdateSettings", () {
    ft.testWidgets("valid update home", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToUserSettingsDialogView()
      when(
        () => mockAppDialogRouter.routeToUserSettingsDialogView()
      ).thenAnswer(
        (_) async => {}
      );

      // AuthRepository.updateUserSettings()
      when(
        () => mockAuthRepository.updateUserSettings(appForm.fields)
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
                          value: "New Settings Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdateSettings(
                          context, formKey, appForm, Routes.home),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAuthRepository.updateUserSettings(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToUserSettingsDialogView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Settings Value!");

      // Check methods were called; check expected values are found
      verify(() => mockAuthRepository.updateUserSettings(appForm.fields)).called(1);
      verify(() => mockAppDialogRouter.routeToUserSettingsDialogView()).called(1);
      expect(formKey.currentState!.validate(), true);
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("valid update landing", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToUserSettingsDialogView()
      when(
        () => mockAppDialogRouter.routeToUserSettingsDialogView()
      ).thenAnswer(
        (_) async => {}
      );

      // AuthRepository.updateUserSettings()
      when(
        () => mockAuthRepository.updateUserSettings(appForm.fields)
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
                          value: "New Settings Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdateSettings(
                          context, formKey, appForm, Routes.landing),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAuthRepository.updateUserSettings(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToUserSettingsDialogView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Settings Value!");

      // Check methods were called; check expected values are found
      verify(() => mockAuthRepository.updateUserSettings(appForm.fields)).called(1);
      verifyNever(() => mockAppDialogRouter.routeToUserSettingsDialogView());
      expect(formKey.currentState!.validate(), true);
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid update", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToUserSettingsDialogView()
      when(
        () => mockAppDialogRouter.routeToUserSettingsDialogView()
      ).thenAnswer(
        (_) async => {}
      );

      // AuthRepository.updateUserSettings()
      when(
        () => mockAuthRepository.updateUserSettings(appForm.fields)
      ).thenAnswer(
        (_) async => (false, {"field3": "Error for field3"})
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
                          value: "New Settings Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdateSettings(
                          context, formKey, appForm, Routes.home),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAuthRepository.updateUserSettings(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToUserSettingsDialogView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check appForm has saved new value
      expect(appForm.getValue(fieldName: fieldName), "New Settings Value!");

      // Check expected values are found; check methods were called
      expect(formKey.currentState!.validate(), true);
      verify(() => mockAuthRepository.updateUserSettings(appForm.fields)).called(1);

      // Check no snackbar; check appForm has error; check method called
      expect(ft.find.byType(SnackBar), ft.findsNothing);
      expect(appForm.getError(fieldName: "field3"), "Error for field3");
      verify(() => mockAppDialogRouter.routeToUserSettingsDialogView()).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final appForm = AppForm()
                      ..setValue(fieldName: fieldName, value: null);

      // GetIt
      final getIt = GetIt.instance;
      final mockAuthRepository = MockAuthRepository();
      final mockAppDialogRouter = MockAppDialogRouter();
      getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
      getIt.registerLazySingleton<AppDialogRouter>(() => mockAppDialogRouter);

      // AppDialogRouter.routeToUserSettingsDialogView()
      when(
        () => mockAppDialogRouter.routeToUserSettingsDialogView()
      ).thenAnswer(
        (_) async => {}
      );

      // AuthRepository.updateUserSettings()
      when(
        () => mockAuthRepository.updateUserSettings(appForm.fields)
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
                          value: "New Settings Value!",
                        ),
                        validator: (value) => "error!",
                      ),
                      ElevatedButton(
                        onPressed: () => submitUpdateSettings(
                          context, formKey, appForm, Routes.home),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check appForm not yet saved;
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check no method calls before submit; no snackbar
      verifyNever(() => mockAuthRepository.updateUserSettings(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToUserSettingsDialogView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is invalid
      expect(formKey.currentState!.validate(), false);

      // Check appForm has not saved new value
      expect(appForm.getValue(fieldName: fieldName), null);

      // Check no method calls after submit; no snackbar
      verifyNever(() => mockAuthRepository.updateUserSettings(appForm.fields));
      verifyNever(() => mockAppDialogRouter.routeToUserSettingsDialogView());
      expect(ft.find.byType(SnackBar), ft.findsNothing);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group("Auth submitLogIn", () {
    ft.testWidgets("valid logIn", (tester) async {
      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final appForm =
        AppForm()
        ..setValue(fieldName: AppFormFields.rebuild, value: func)
        ..setValue(fieldName: SignInField.usernameOrEmail, value: "username")
        ..setValue(fieldName: UserField.password, value: "password");

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<PocketBase>(() => pb);

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
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.authWithPassword()
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenAnswer(
        (_) async => RecordAuth()
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var testRouter = GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => TestLogin(
              appForm: appForm,
              fieldName: fieldName,
              formKey: formKey,
            )
          ),
          GoRoute(
            path: Routes.landing,
            builder: (_, __) => BlankPage()
          )
        ]);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check testList initially has values
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit
      verifyNever(() => recordService.authWithPassword(any(), any()));
      verifyNever(() => recordService.getFirstListItem(
        "${GenericField.id} = '${tc.user.id}'")
      );
      verifyNever(() => recordService.getFirstListItem(
        "${UserSettingsField.user} = '${tc.user.id}'")
      );

      // Tap ElevatedButton (to call submitLogIn)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods were called
      verify(() => recordService.authWithPassword(any(), any())).called(1);
      verify(() => recordService.getFirstListItem(
        "${GenericField.id} = '${tc.user.id}'")
      ).called(1);
      verify(() => recordService.getFirstListItem(
        "${UserSettingsField.user} = '${tc.user.id}'")
      ).called(1);

      // Check testList still has values (no error)
      expect(testList.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid logIn", (tester) async {
      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final appForm =
        AppForm()
        ..setValue(fieldName: AppFormFields.rebuild, value: func)
        ..setValue(fieldName: SignInField.usernameOrEmail, value: "username")
        ..setValue(fieldName: UserField.password, value: "password");

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<PocketBase>(() => pb);

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
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.authWithPassword()
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenThrow(
        tc.clientException
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var testRouter = GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => TestLogin(
              appForm: appForm,
              fieldName: fieldName,
              formKey: formKey,
            )
          ),
          GoRoute(
            path: Routes.landing,
            builder: (_, __) => BlankPage()
          )
        ]);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check testList initially has values
      expect(testList.isEmpty, false);

      // Check no method calls before submit
      verifyNever(() => recordService.authWithPassword(any(), any()));
      verifyNever(() => recordService.getFirstListItem(
        "${GenericField.id} = '${tc.user.id}'")
      );
      verifyNever(() => recordService.getFirstListItem(
        "${UserSettingsField.user} = '${tc.user.id}'")
      );

      // Tap ElevatedButton (to call submitLogIn)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check authWithPassword called
      verify(() => recordService.authWithPassword(any(), any())).called(1);

      // Check other methods were not called
      verifyNever(() => recordService.getFirstListItem(
        "${GenericField.id} = '${tc.user.id}'")
      );
      verifyNever(() => recordService.getFirstListItem(
        "${UserSettingsField.user} = '${tc.user.id}'")
      );

      // Check testList is empty (error); check appForm has errors
      expect(testList.isEmpty, true);
      expect(
        appForm.getError(fieldName: SignInField.usernameOrEmail),
        AppFormText.invalidEmailOrPassword
      );
      expect(
        appForm.getError(fieldName: UserField.password),
        AppFormText.invalidEmailOrPassword
      );
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final appForm =
        AppForm()
        ..setValue(fieldName: AppFormFields.rebuild, value: func)
        ..setValue(fieldName: SignInField.usernameOrEmail, value: "username")
        ..setValue(fieldName: UserField.password, value: "password");

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<PocketBase>(() => pb);

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
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );
      when(
        () => pb.collection(Collection.userSettings)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.authWithPassword()
      when(
        () => recordService.authWithPassword(any(), any())
      ).thenAnswer(
        (_) async => RecordAuth()
      );

      // RecordService.getFirstListItem()
      when(
        () => recordService.getFirstListItem("${GenericField.id} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.getFirstListItem(
          "${UserSettingsField.user} = '${tc.user.id}'")
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      var testRouter = GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => TestLogin(
              appForm: appForm,
              fieldName: fieldName,
              formKey: formKey,
              validatorReturnVal: "error!"
            )
          ),
          GoRoute(
            path: Routes.landing,
            builder: (_, __) => BlankPage()
          )
        ]);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // Check testList initially has values
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit
      verifyNever(() => recordService.authWithPassword(any(), any()));
      verifyNever(() => recordService.getFirstListItem(
        "${GenericField.id} = '${tc.user.id}'")
      );
      verifyNever(() => recordService.getFirstListItem(
        "${UserSettingsField.user} = '${tc.user.id}'")
      );

      // Tap ElevatedButton (to call submitLogIn)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is invalid
      expect(formKey.currentState!.validate(), false);

      // Check no methods were called
      verifyNever(() => recordService.authWithPassword(any(), any()));
      verifyNever(() => recordService.getFirstListItem(
        "${GenericField.id} = '${tc.user.id}'")
      );
      verifyNever(() => recordService.getFirstListItem(
        "${UserSettingsField.user} = '${tc.user.id}'")
      );

      // Check testList still has values (no error)
      expect(testList.isNotEmpty, true);
    });

    tearDown(() => GetIt.instance.reset());
  });

  group ("Auth submitSignUp", () {
    ft.testWidgets("valid signUp", (tester) async {
      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      const email = "testEmail";
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final appForm =
        AppForm()
        ..setValue(fieldName: AppFormFields.rebuild, value: func)
        ..setValue(fieldName: UserField.firstName, value: "firstName")
        ..setValue(fieldName: UserField.lastName, value: "lastName")
        ..setValue(fieldName: UserField.username, value: "username")
        ..setValue(fieldName: UserField.email, value: email)
        ..setValue(fieldName: UserField.password, value: "password")
        ..setValue(fieldName: UserField.passwordConfirm, value: "passwordConfirm");

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.collection()
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

      // RecordService.create()
      when(
        () => recordService.create(body: {
          UserField.email: email,
          UserField.firstName: appForm.getValue(fieldName: UserField.firstName),
          UserField.lastName: appForm.getValue(fieldName: UserField.lastName),
          UserField.password: appForm.getValue(fieldName: UserField.password),
          UserField.passwordConfirm: appForm.getValue(
            fieldName: UserField.passwordConfirm),
          UserField.username: appForm.getValue(fieldName: UserField.username),
          UserField.emailVisibility: false,
        })
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );
      when(
        () => recordService.create(body: {
          UserSettingsField.defaultCurrency: "",
          UserSettingsField.defaultInstructions: "",
          UserSettingsField.user: tc.getUserRecordModel().id,
        })
      ).thenAnswer(
        (_) async => tc.getUserSettingsRecordModel()
      );

      // RecordService.requestVerification()
      when(
        () => recordService.requestVerification(email)
      ).thenAnswer(
        (_) async => {}
      );

      // NOTE: _tabController is added to appForm within TestTabView
      await tester.pumpWidget(
        TestTabView(
          appForm: appForm,
          fieldName: fieldName,
          formKey: formKey,
          pb: pb)
      );

      // Check testList initially has values
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit; no snackbar
      verifyNever(() => recordService.create(body: any(named: "body")));
      verifyNever(() => recordService.requestVerification(email));
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitSignUp)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is valid
      expect(formKey.currentState!.validate(), true);

      // Check methods were called; snackbar shows
      verify(() => recordService.create(body: {
        UserField.email: email,
        UserField.firstName: appForm.getValue(fieldName: UserField.firstName),
        UserField.lastName: appForm.getValue(fieldName: UserField.lastName),
        UserField.password: appForm.getValue(fieldName: UserField.password),
        UserField.passwordConfirm: appForm.getValue(
          fieldName: UserField.passwordConfirm),
        UserField.username: appForm.getValue(fieldName: UserField.username),
        UserField.emailVisibility: false,
      })).called(1);
      verify(() => recordService.create(body: {
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
        UserSettingsField.user: tc.getUserRecordModel().id,
      })).called(1);
      verify(() => recordService.requestVerification(email)).called(1);
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);

      // Check testList still has values (no error)
      expect(testList.isNotEmpty, true);
    });

    ft.testWidgets("invalid signUp", (tester) async {
      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      const email = "testEmail";
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final appForm =
        AppForm()
        ..setValue(fieldName: AppFormFields.rebuild, value: func)
        ..setValue(fieldName: UserField.firstName, value: "firstName")
        ..setValue(fieldName: UserField.lastName, value: "lastName")
        ..setValue(fieldName: UserField.username, value: "username")
        ..setValue(fieldName: UserField.email, value: email)
        ..setValue(fieldName: UserField.password, value: "password")
        ..setValue(fieldName: UserField.passwordConfirm, value: "passwordConfirm");

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create()
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      // RecordService.requestVerification()
      when(
        () => recordService.requestVerification(email)
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        TestTabView(
          appForm: appForm,
          fieldName: fieldName,
          formKey: formKey,
          pb: pb)
      );

      // Check testList initially has values
      expect(testList.isEmpty, false);

      // Check no method calls before submit; no snackbar
      verifyNever(() => recordService.create(body: any(named: "body")));
      verifyNever(() => recordService.requestVerification(email));
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitSignUp)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is valid
      expect(formKey.currentState!.validate(), true);

      // Check methods were called; no snackbar
      verify(() => recordService.create(body: any(named: "body"))).called(1);
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Check no email sent
      verifyNever(() => recordService.requestVerification(email));

      // Check testList is now empty (error); check appForm has error assigned
      expect(testList.isEmpty, true);
      expect(
        appForm.getError(fieldName: "FieldKey"),
        "The inner map message of signup()"
      );
    });

    ft.testWidgets("invalid form", (tester) async {
      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const fieldName = "champs";
      const email = "testEmail";
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final appForm =
        AppForm()
        ..setValue(fieldName: AppFormFields.rebuild, value: func)
        ..setValue(fieldName: UserField.firstName, value: "firstName")
        ..setValue(fieldName: UserField.lastName, value: "lastName")
        ..setValue(fieldName: UserField.username, value: "username")
        ..setValue(fieldName: UserField.email, value: email)
        ..setValue(fieldName: UserField.password, value: "password")
        ..setValue(fieldName: UserField.passwordConfirm, value: "passwordConfirm");

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create()
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getUserRecordModel()
      );

      // RecordService.requestVerification()
      when(
        () => recordService.requestVerification(email)
      ).thenAnswer(
        (_) async => {}
      );

      await tester.pumpWidget(
        TestTabView(
          appForm: appForm,
          fieldName: fieldName,
          formKey: formKey,
          pb: pb,
          validatorReturnVal: "error",
        )
      );

      // Check testList initially has values
      expect(testList.isNotEmpty, true);

      // Check no method calls before submit; no snackbar
      verifyNever(() => recordService.create(body: any(named: "body")));
      verifyNever(() => recordService.requestVerification(email));
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitSignUp)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check form is valid
      expect(formKey.currentState!.validate(), false);

      // Check still no method calls; no snackbar
      verifyNever(() => recordService.create(body: any(named: "body")));
      verifyNever(() => recordService.requestVerification(email));
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Check testList still has values (no error)
      expect(testList.isNotEmpty, true);
    });
  });

  group("Auth submitForgotPassword", () {
    ft.testWidgets("valid submitForgotPassword", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const email = "testEmail";
      final appForm = AppForm()
                      ..setValue(fieldName: UserField.email, value: email);

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.requestPasswordReset()
      when(
        () => recordService.requestPasswordReset(email)
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
                          fieldName: "fieldName",
                          value: "New Random Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitForgotPassword(
                          context, formKey, appForm, database: pb),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check no method calls before submit
      // NOTE: Can't check snackbar due to inner Navigator.pop()
      verifyNever(() => recordService.requestPasswordReset(email));

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods were called
      // NOTE: Can't check snackbar due to inner Navigator.pop()
      verify(() => recordService.requestPasswordReset(email)).called(1);
    });

    ft.testWidgets("invalid submitForgotPassword", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final tc = TestContext();

      // AppForm
      const email = "testEmail";
      final appForm = AppForm()
                      ..setValue(fieldName: UserField.email, value: email);

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.requestPasswordReset()
      when(
        () => recordService.requestPasswordReset(email)
      ).thenThrow(
        tc.clientException
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
                          fieldName: "fieldName",
                          value: "New Random Value!",
                        ),
                        validator: (value) => null,
                      ),
                      ElevatedButton(
                        onPressed: () => submitForgotPassword(
                          context, formKey, appForm, database: pb),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check no method calls before submit
      // NOTE: Can't check snackbar due to inner Navigator.pop()
      verifyNever(() => recordService.requestPasswordReset(email));

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check methods were called
      // NOTE: Can't check snackbar due to inner Navigator.pop()
      verify(() => recordService.requestPasswordReset(email)).called(1);
    });

    ft.testWidgets("invalid form", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      // AppForm
      const email = "testEmail";
      final appForm = AppForm()
                      ..setValue(fieldName: UserField.email, value: email);

      // pb
      final pb = MockPocketBase();
      final recordService = MockRecordService();

      // pb.collection()
      when(
        () => pb.collection(Collection.users)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.requestPasswordReset()
      when(
        () => recordService.requestPasswordReset(email)
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
                          fieldName: "fieldName",
                          value: "New Random Value!",
                        ),
                        validator: (value) => "error",
                      ),
                      ElevatedButton(
                        onPressed: () => submitForgotPassword(
                          context, formKey, appForm, database: pb),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              })
          ),
        )
      );

      // Check no method calls before submit
      verifyNever(() => recordService.requestPasswordReset(email));

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check that form is invalid
      expect(formKey.currentState!.validate(), false);

      // Check methods were never called
      verifyNever(() => recordService.requestPasswordReset(email));
    });
  });
}