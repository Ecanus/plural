import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:mocktail/mocktail.dart";
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_hyperlinkable_text.dart';

// Tests
import '../tester_functions.dart';
import '../test_mocks.dart';

void main() {
  /// MockUrlLauncher code taken from: https://stackoverflow.com/a/74128795
  /// tapTextSpan code taken from: https://stackoverflow.com/a/60247474
  group("AppHyperlinkableText test", () {
    testWidgets("launchUrl false", (tester) async {
      const text = "[Fake Url](https://fakeurl.com)";

      // UrlLauncher Mock
      var mockLauncher = MockUrlLauncher();
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
            body: Builder(
              builder: (BuildContext context) {
                return AppHyperlinkableText(
                  text: text,
                );
              }
            ),
          ),
      ));

      expect(find.byType(SelectableText), findsOneWidget);

      // Check that markdown has been reformatted
      expect(find.text(text), findsNothing);
      expect(find.text("Fake Url"), findsOneWidget);

      // Check snackbar not displayed yet
      expect(find.byType(SnackBar), findsNothing);

      // Tap the link (found in the TextSpan)
      tapTextSpan(get<SelectableText>(tester), "Fake Url");
      await tester.pumpAndSettle();

      // Check that the stubbed method was called
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);

      // Check snackbar displayed (due to launchUrl returning false)
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets("launchUrl exception", (tester) async {
      const text = "[Fake Url](https://fakeurl.com)";

      // UrlLauncher Mock
      var mockLauncher = MockUrlLauncher();
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
            body: Builder(
              builder: (BuildContext context) {
                return AppHyperlinkableText(
                  text: text,
                );
              }
            ),
          ),
      ));

      expect(find.byType(SelectableText), findsOneWidget);

      // Check that markdown has been reformatted
      expect(find.text(text), findsNothing);
      expect(find.text("Fake Url"), findsOneWidget);

      // Check snackbar not displayed yet
      expect(find.byType(SnackBar), findsNothing);

      // Tap the link (found in the TextSpan)
      tapTextSpan(get<SelectableText>(tester), "Fake Url");
      await tester.pumpAndSettle();

      // Check that the stubbed method was called
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);

      // Check snackbar displayed (due to exception)
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets("launchUrl true", (tester) async {
      const text = "[Fake Url](https://fakeurl.com)";

      // UrlLauncher Mock
      var mockLauncher = MockUrlLauncher();
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
          home: AppHyperlinkableText(
            text: text,
          ),
      ));

      expect(find.byType(SelectableText), findsOneWidget);

      // Check that markdown has been reformatted
      expect(find.text(text), findsNothing);
      expect(find.text("Fake Url"), findsOneWidget);

      // Tap the link (found in the TextSpan)
      tapTextSpan(get<SelectableText>(tester), "Fake Url");

      // Check that the stubbed method was called
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);
    });
  });
}