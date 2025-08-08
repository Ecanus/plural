

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Utils
import 'package:plural_app/src/utils/utils_api.dart';

class MockClipboard {
  MockClipboard({this.hasStringsThrows = false});

  final bool hasStringsThrows;

  dynamic clipboardData = <String, dynamic>{'text': null};

  Future<Object?> handleMethodCall(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Clipboard.getData':
        return clipboardData;
      case 'Clipboard.hasStrings':
        if (hasStringsThrows) {
          throw Exception();
        }
        final Map<String, dynamic>? clipboardDataMap = clipboardData as Map<String, dynamic>?;
        final String? text = clipboardDataMap?['text'] as String?;
        return <String, bool>{'value': text != null && text.isNotEmpty};
      case 'Clipboard.setData':
        clipboardData = methodCall.arguments;
    }
    return null;
  }
}

void main() {
  group("utils_api", () {
    testWidgets("copyToClipboard", (tester) async {
      final MockClipboard mockClipboard = MockClipboard();

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        mockClipboard.handleMethodCall,
      );

      final stringToCopy = "test";

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => copyToClipboard(context, stringToCopy),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      mockClipboard.clipboardData = <String, dynamic>{'text': 'Hello world'};

      // Tap ElevatedButton (to call method)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}