import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class ShowHidePasswordButton extends StatelessWidget {
  const ShowHidePasswordButton({
    required this.callback,
    required this.isPasswordVisible,
  });

  final Function callback;
  final Function isPasswordVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppPaddings.p15
      ),
      child: IconButton(
        onPressed: () => callback(),
        icon: Icon(
          isPasswordVisible()
          ? Icons.visibility
          : Icons.visibility_off_rounded
        )
      ),
    );
  }
}