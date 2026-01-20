import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/report_bug_button.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../test_mocks.dart';

void main() {
  /// MockUrlLauncher code taken from: https://stackoverflow.com/a/74128795
  group("ReportBugButton", () {
    testWidgets("widgets", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportBugButton()
          )
        )
      );

      // Check widgets are displayed
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text(UserSettingsViewText.reportBugButton), findsOneWidget);
    });

    testWidgets("launchUrl false", (tester) async {
      // UrlLauncher Mock
      final mockLauncher = MockUrlLauncher();
      UrlLauncherPlatform.instance = mockLauncher;
      registerFallbackValue(const LaunchOptions());

      // UrlLauncherPlatform.launchURL()
      when(
        () => mockLauncher.launchUrl(any(), any())
      ).thenAnswer(
        (_) async => false
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportBugButton()
          )
        )
      );

      // Check snackbar not displayed yet
      expect(find.byType(SnackBar), findsNothing);

      // Press button (to launch Url)
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Check that the stubbed method was called
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);

      // Check snackbar displayed (due to exception)
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets("launchUrl exception", (tester) async {
      // UrlLauncher Mock
      final mockLauncher = MockUrlLauncher();
      UrlLauncherPlatform.instance = mockLauncher;
      registerFallbackValue(const LaunchOptions());

      // UrlLauncherPlatform.launchURL()
      when(
        () => mockLauncher.launchUrl(any(), any())
      ).thenThrow(
        PlatformException(code: "testcode")
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportBugButton()
          )
        )
      );

      // Check snackbar not displayed yet
      expect(find.byType(SnackBar), findsNothing);

      // Press button (to launch Url)
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Check that the stubbed method was called
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);

      // Check snackbar displayed (due to exception)
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets("launchUrl true", (tester) async {
      // UrlLauncher Mock
      final mockLauncher = MockUrlLauncher();
      UrlLauncherPlatform.instance = mockLauncher;
      registerFallbackValue(const LaunchOptions());

      // UrlLauncherPlatform.launchURL()
      when(
        () => mockLauncher.launchUrl(any(), any())
      ).thenAnswer(
        (_) async => true
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportBugButton()
          )
        )
      );

      // Press button (to launch Url)
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Check that the stubbed method was called
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);
    });
  });
}