import 'package:flutter/services.dart';

/// Copies the given [content] to the system's clipboard.
Future<void> copyToClipboard(
  String content, {
  required void Function() callback
}) async {
  await Clipboard.setData(ClipboardData(text: content));

  callback();
}