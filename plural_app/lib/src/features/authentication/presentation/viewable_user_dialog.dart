import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class UserDialogViewForm extends StatelessWidget {
  const UserDialogViewForm({
    super.key,
    required this.user,
  });

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [],
          ),
        ),
      ],
    );
  }
}