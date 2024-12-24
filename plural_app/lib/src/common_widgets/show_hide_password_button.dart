import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class ShowHidePasswordButton extends StatelessWidget {
  const ShowHidePasswordButton({
    super.key,
    required this.isPasswordVisible,
    required this.onPressed,
  });

  final Function isPasswordVisible;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppPaddings.p15
      ),
      child: IconButton(
        onPressed: () => onPressed(),
        icon: Icon(
          isPasswordVisible()
          ? Icons.visibility
          : Icons.visibility_off_rounded
        )
      ),
    );
  }
}