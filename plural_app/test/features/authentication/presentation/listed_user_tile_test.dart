import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/listed_user_tile.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("ListedUserTile test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [ListedUserTile(user: tc.user)],
                  )
                ),
              ],
            )
          )
        )
      );

      // Check username is displayed
      expect(find.text(tc.user.username), findsOneWidget);
    });
  });
}