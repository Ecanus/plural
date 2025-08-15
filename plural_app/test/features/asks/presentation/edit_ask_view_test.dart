import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_checkbox_list_tile_form_field.dart';
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/delete_ask_button.dart';
import 'package:plural_app/src/features/asks/presentation/edit_ask_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../tester_functions.dart';

void main() {
  group("EditAskView", () {
    testWidgets("widgets", (tester) async {
      final ask = AskFactory();

      // GetIt
      final getIt = GetIt.instance;
      final mockAppState = MockAppState();
      final mockAsksRepository = MockAsksRepository();
      getIt.registerLazySingleton<AppState>(() => mockAppState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);

      // AppState.verify()
      when(
        () => mockAppState.verify([AppUserGardenPermission.createAndEditAsks])
      ).thenAnswer(
        (_) async => {}
      );

      // AppState.timelineAsks
      when(
        () => mockAppState.timelineAsks
      ).thenAnswer(
        (_) => [ask]
      );

      // AsksRepository.delete()
      when(
        () => mockAsksRepository.delete(id: ask.id)
      ).thenAnswer(
        (_) async => (true, {})
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createEditAskDialog(context: context, ask: ask),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check AskDialogEditForm not yet displayed
      expect(find.byType(EditAskView), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(EditAskView), findsOneWidget);
      expect(find.byType(EditAskHeader), findsOneWidget);
      expect(find.byType(AppDatePickerFormField), findsOneWidget);
      expect(find.byType(AppTextFormField), findsNWidgets(5));
      expect(find.byType(AppCurrencyPickerFormField), findsOneWidget);
      expect(find.byType(AppCheckboxListTileFormField), findsOneWidget);
      expect(find.byType(DeleteAskButton), findsOneWidget);
      expect(find.byType(AppDialogFooterBufferSubmitButton), findsOneWidget);

      // Tap DeleteAskButton (to open another dialog)
      await tester.ensureVisible(find.byType(DeleteAskButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DeleteAskButton));
      await tester.pumpAndSettle();

      // Check ConfirmDeleteAskDialog has been created
      expect(find.byType(ConfirmDeleteAskDialog), findsOneWidget);

      // Check verify() and delete() not yet called
      verifyNever(() => mockAppState.verify(
        [AppUserGardenPermission.createAndEditAsks]));
      verifyNever(() => mockAsksRepository.delete(id: ask.id));

      await tester.tap(find.byType(FilledButton));

      // Check verify() and delete() were called
      verify(() => mockAppState.verify(
        [AppUserGardenPermission.createAndEditAsks])).called(1);
      verify(() => mockAsksRepository.delete(id: ask.id)).called(1);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("IsOnTimelineLabel", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsOnTimelineLabel(isOnTimeline: true);
              }
            )
          ),
        )
      );

      // isOnTimeline == true, color is positiveColor, icon is local_florist
      expect(find.byIcon(Icons.local_florist), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_rounded), findsNothing);
      expect(get<Icon>(tester).color, AppThemes.positiveColor);

      // isOnTimeline == true, text is visibleOnTimeline
      expect(find.text(AskViewText.visibleOnTimeline), findsOneWidget);
      expect(find.text(AskViewText.notVisibleOnTimeline), findsNothing);
      expect(get<Text>(tester).style!.color, AppThemes.positiveColor);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsOnTimelineLabel(isOnTimeline: false);
              }
            )
          ),
        )
      );

      // isOnTimeline == false, color is onPrimaryFixed, icon is visibility_off_rounded
      expect(find.byIcon(Icons.local_florist), findsNothing);
      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
      expect(get<Icon>(tester).color, AppThemes.colorScheme.onPrimaryFixed);

      // isOnTimeline == false, text is notVisibleOnTimeline
      expect(find.text(AskViewText.visibleOnTimeline), findsNothing);
      expect(find.text(AskViewText.notVisibleOnTimeline), findsOneWidget);
      expect(
        get<Text>(tester).style!.color,
        AppThemes.standard.colorScheme.onPrimaryFixed
      );
    });

    testWidgets("IsDeadlinePassedLabel", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsDeadlinePassedLabel(
                  isDeadlinePassed: false,
                  isTargetMet: true
                );
              }
            )
          ),
        )
      );

      // isDeadlinePassed == false, find nothing
      expect(find.byType(Icon), findsNothing);
      expect(find.byType(Text), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsDeadlinePassedLabel(
                  isDeadlinePassed: false,
                  isTargetMet: false
                );
              }
            )
          ),
        )
      );

      // isDeadlinePassed == false, find nothing
      expect(find.byType(Icon), findsNothing);
      expect(find.byType(Text), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsDeadlinePassedLabel(
                  isDeadlinePassed: true,
                  isTargetMet: true
                );
              }
            )
          ),
        )
      );

      // isTargetMet == true, color is onPrimaryFixed
      expect(find.byType(Icon), findsOneWidget);
      expect(get<Icon>(tester).color, AppThemes.standard.colorScheme.onPrimaryFixed);

      expect(find.byType(Text), findsOneWidget);
      expect(
        get<Text>(tester).style!.color,
        AppThemes.standard.colorScheme.onPrimaryFixed
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsDeadlinePassedLabel(
                  isDeadlinePassed: true,
                  isTargetMet: false
                );
              }
            )
          ),
        )
      );

      // isTargetMet == false, color is error
      expect(find.byType(Icon), findsOneWidget);
      expect(get<Icon>(tester).color, AppThemes.standard.colorScheme.error);

      expect(find.byType(Text), findsOneWidget);
      expect(
        get<Text>(tester).style!.color,
        AppThemes.standard.colorScheme.error
      );
    });

    testWidgets("IsTargetMetLabel", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsTargetMetLabel(
                  isTargetMet: true
                );
              }
            )
          ),
        )
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.not_interested), findsNothing);
      expect(get<Icon>(tester).color, AppThemes.positiveColor);

      expect(find.text(AskViewText.targetMet), findsOneWidget);
      expect(find.text(AskViewText.targetNotMet), findsNothing);
      expect(get<Text>(tester).style!.color, AppThemes.positiveColor);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return IsTargetMetLabel(
                  isTargetMet: false
                );
              }
            )
          ),
        )
      );

      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.not_interested), findsOneWidget);
      expect(get<Icon>(tester).color, AppThemes.standard.colorScheme.onPrimaryFixed);

      expect(find.text(AskViewText.targetMet), findsNothing);
      expect(find.text(AskViewText.targetNotMet), findsOneWidget);
      expect(
        get<Text>(tester).style!.color,
        AppThemes.standard.colorScheme.onPrimaryFixed);
    });
  });
}