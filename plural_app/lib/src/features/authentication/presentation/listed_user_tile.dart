import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class ListedUserTile extends StatelessWidget {
  const ListedUserTile({
    required this.user,
  });

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: AppElevations.e0,
      child: ListTile(
        title: Text(
          user.username,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        onTap: null,
      ),
    );
  }
}