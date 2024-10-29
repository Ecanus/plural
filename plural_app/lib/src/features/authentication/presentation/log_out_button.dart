import 'package:flutter/material.dart';
import 'package:plural_app/src/constants/app_sizes.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppWidths.w150,
      height: AppHeights.h40,
      child: ElevatedButton.icon(
        onPressed: () => logout(context),
        label: Text(Labels.logout),
        icon: Icon(Icons.login_outlined)
      ),
    );
  }
}