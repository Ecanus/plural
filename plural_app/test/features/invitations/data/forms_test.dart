import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/forms.dart';
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("submitCreate", () {
    ft.testWidgets("valid create", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final tc = TestContext();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      final appForm = AppForm.fromMap(Invitation.emptyMap())
        ..setValue(
          fieldName: InvitationField.type,
          value: InvitationType.open.name)
        ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true);

      final getIt = GetIt.instance;
      final mockAppDialogViewRouter = MockAppDialogViewRouter();
      final mockAppState = MockAppState();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).thenAnswer(
        (_) async => {}
      );

      // InvitationsRepository.create (Open Invitation)
      when(
        () => mockInvitationsRepository.create(
          body: appForm.fields
        )
      ).thenAnswer(
        (_) async => (tc.getOpenInvitationRecordModel(), {})
      );

      // AppDialogViewRouter.routeToAdminOptionsView()
      when(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
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
                      ElevatedButton(
                        onPressed: () => submitCreate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              }
            )
          ),
        )
      );

      // Check no function calls yet; no snackBar
      expect(testList.isEmpty, false);
      verifyNever(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockInvitationsRepository.create(body: appForm.fields)
      );
      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
      );
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check function calls; snackBar shows; testList still not empty (i.e. no error)
      expect(testList.isEmpty, false);
      verify(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).called(1);
      verify(
        () => mockInvitationsRepository.create(body: appForm.fields)
      ).called(1);
      verify(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
      ).called(1);
      expect(formKey.currentState!.validate(), true);
      expect(ft.find.byType(SnackBar), ft.findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid create", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      final appForm = AppForm.fromMap(Invitation.emptyMap())
        ..setValue(
          fieldName: InvitationField.type,
          value: InvitationType.open.name)
        ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true);

      final getIt = GetIt.instance;
      final mockAppDialogViewRouter = MockAppDialogViewRouter();
      final mockAppState = MockAppState();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).thenAnswer(
        (_) async => {}
      );

      // InvitationsRepository.create (Open Invitation). Returns null recordModel and non-null errorsMap
      when(
        () => mockInvitationsRepository.create(
          body: appForm.fields
        )
      ).thenAnswer(
        (_) async => (null, {InvitationField.type: "Error for type"})
      );

      // AppDialogViewRouter.routeToAdminOptionsView()
      when(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
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
                      ElevatedButton(
                        onPressed: () => submitCreate(context, formKey, appForm),
                        child: Text("x")
                      ),
                    ],
                  ),
                );
              }
            )
          ),
        )
      );

      // Check no function calls yet; no snackBar
      expect(testList.isEmpty, false);
      verifyNever(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockInvitationsRepository.create(body: appForm.fields)
      );
      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
      );
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check function calls; snackBar shows; testList now empty (i.e. error)
      expect(testList.isEmpty, true);
      verify(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).called(1);
      verify(
        () => mockInvitationsRepository.create(body: appForm.fields)
      ).called(1);
      expect(formKey.currentState!.validate(), true);
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // No reroute
      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
      );
    });

    tearDown(() => GetIt.instance.reset());

    ft.testWidgets("invalid form", (tester) async {
      final testList = [1, 2, 3];
      void func() => testList.clear();

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      final appForm = AppForm.fromMap(Invitation.emptyMap())
        ..setValue(
          fieldName: InvitationField.type,
          value: InvitationType.open.name)
        ..setValue(fieldName: AppFormFields.rebuild, value: func, isAux: true);

      final getIt = GetIt.instance;
      final mockAppDialogViewRouter = MockAppDialogViewRouter();
      final mockAppState = MockAppState();
      final mockInvitationsRepository = MockInvitationsRepository();
      final mockUsersRepository = MockUsersRepository();

      getIt.registerLazySingleton<AppDialogViewRouter>(() => mockAppDialogViewRouter);
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<InvitationsRepository>(
        () => mockInvitationsRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      ).thenAnswer(
        (_) async => {}
      );

      // InvitationsRepository.create (Open Invitation). Returns null recordModel and non-null errorsMap
      when(
        () => mockInvitationsRepository.create(
          body: appForm.fields
        )
      ).thenAnswer(
        (_) async => (null, {InvitationField.type: "Error for type"})
      );

      // AppDialogViewRouter.routeToAdminOptionsView()
      when(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
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
              }
            )
          ),
        )
      );

      // Check no function calls yet; no snackBar
      expect(testList.isEmpty, false);
      verifyNever(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockInvitationsRepository.create(body: appForm.fields)
      );
      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
      );
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // Tap ElevatedButton (to call submitCreate)
      await tester.tap(ft.find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check functions still not called; still no snackBar; testList still has values
      expect(testList.isEmpty, false);
      verifyNever(
        () => mockAppState.verify([AppUserGardenPermission.createInvitations])
      );
      verifyNever(
        () => mockInvitationsRepository.create(body: appForm.fields)
      );
      expect(formKey.currentState!.validate(), false);
      expect(ft.find.byType(SnackBar), ft.findsNothing);

      // No reroute
      verifyNever(
        () => mockAppDialogViewRouter.routeToAdminOptionsView()
      );
    });

    tearDown(() => GetIt.instance.reset());

  });
}
