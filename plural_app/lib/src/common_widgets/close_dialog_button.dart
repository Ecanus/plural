import 'package:flutter/material.dart';

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: CircleBorder()
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.close),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}