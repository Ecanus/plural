import 'package:flutter/material.dart';

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
    return IconButton(
      onPressed: () => onPressed(),
      icon: Icon(
        isPasswordVisible()
        ? Icons.visibility
        : Icons.visibility_off_rounded
      )
    );
  }
}