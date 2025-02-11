import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/presentation/listed_users_button.dart';

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
        AppDialogHeader(firstHeaderButton: ListedUsersButton(),),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              // AppTextFormFieldFilled(
              //   label: Strings.userFirstNameLabel,
              //   value: user.firstName
              // ),
              // AppTextFormFieldFilled(
              //   label: Strings.userLastNameLabel,
              //   value: user.lastName
              // ),
            ],
          ),
        ),
      ],
    );
  }
}