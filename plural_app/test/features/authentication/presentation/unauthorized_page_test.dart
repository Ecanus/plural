import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plural_app/src/common_widgets/app_logo.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_button.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

void main() {
  group("UnauthorizedPage test", () {
    testWidgets("null previousRoute", (tester) async {
      final testRouter = GoRouter(
        initialLocation: Routes.unauthorized,
        routes: [
          GoRoute(
            path: Routes.signIn,
            builder: (_, __) => SizedBox(child: Text("testSignInReroute"),)
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return UnauthorizedPage();
                }
              )
            )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      expect(find.text(UnauthorizedPageText.messageHeader), findsOneWidget);
      expect(find.text(UnauthorizedPageText.messageBody), findsOneWidget);

      final appTextButton = find.byType(AppTextButton);
      expect(appTextButton, findsOneWidget);

      expect(find.text("testSignInReroute"), findsNothing);

      await tester.tap(appTextButton);
      await tester.pumpAndSettle();

      expect(find.text("testSignInReroute"), findsOneWidget);
    });

    testWidgets("non null previousRoute", (tester) async {
      final testRouter = GoRouter(
        initialLocation: Routes.unauthorized,
        routes: [
          GoRoute(
            path: Routes.signIn,
            builder: (_, __) => SizedBox(child: Text("testSignInReroute"),)
          ),
          GoRoute(
            path: "/test",
            builder: (_, __) => SizedBox(child: Text("testTestReroute"),)
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return UnauthorizedPage(previousRoute: "/test",);
                }
              )
            )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      expect(find.text(UnauthorizedPageText.messageHeader), findsOneWidget);
      expect(find.text(UnauthorizedPageText.messageBody), findsOneWidget);

      final appTextButton = find.byType(AppTextButton);
      expect(appTextButton, findsOneWidget);

      expect(find.text("testSignInReroute"), findsNothing);
      expect(find.text("testTestReroute"), findsNothing);

      await tester.tap(appTextButton);
      await tester.pumpAndSettle();

      // Test redirected to /test and not to /signin
      expect(find.text("testSignInReroute"), findsNothing);
      expect(find.text("testTestReroute"), findsOneWidget);
    });

    testWidgets("appLogo", (tester) async {
      final dpi = tester.view.devicePixelRatio;

      final testRouter = GoRouter(
        initialLocation: Routes.unauthorized,
        routes: [
          GoRoute(
            path: Routes.signIn,
            builder: (_, __) => SizedBox(child: Text("testSignInReroute"),)
          ),
          GoRoute(
            path: Routes.unauthorized,
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return UnauthorizedPage();
                }
              )
            )
          )
        ]
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        )
      );

      // height > 800
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 1200 * dpi);
      await tester.pumpAndSettle();
      expect(find.byType(AppLogo), findsOneWidget);

      // height < 800
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 700 * dpi);
      await tester.pumpAndSettle();
      expect(find.byType(AppLogo), findsNothing);
    });
  });
}