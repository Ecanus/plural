import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/log_in_tab.dart';
import 'package:plural_app/src/features/authentication/presentation/sign_in_page.dart';
import 'package:plural_app/src/features/authentication/presentation/sign_up_tab.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

void main() {
  group("SignInPage test", () {
    testWidgets("widgets", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInPage()
          )
        )
      );

      final signUpTab = find.text(SignInPageText.signUp);

      // Check tabs rendered (2 for logIn because of Tab and Button)
      expect(find.text(SignInPageText.logIn), findsNWidgets(2));
      expect(signUpTab, findsOneWidget);

      // Check only LogIn tab rendered fully; SignUp tab not rendered
      expect(find.byType(LogInTab), findsOneWidget);
      expect(find.byType(SignUpTab), findsNothing);

      // Tap on Settings tab
      await tester.tap(signUpTab);
      await tester.pumpAndSettle();

      // Check only SignUp tab rendered fully; LogIn tab not rendered
      expect(find.byType(LogInTab), findsNothing);
      expect(find.byType(SignUpTab), findsOneWidget);
    });
  });
}