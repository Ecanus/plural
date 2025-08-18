import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/styles.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';
import 'package:plural_app/src/features/invitations/presentation/landing_page_invitation_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';
import 'package:plural_app/src/utils/app_state.dart';

class LandingPageInvitationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              AppDialogCategoryHeader(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: AppFontSizes.s20,
                fontWeight: FontWeight.w500,
                text: LandingPageText.openInvitationCode
              ),
              gapH30,
              OpenInvitationCodeTextField(),
              PrivateInvitationsListView(),
            ],
          ),
        )
      ],
    );
  }
}

class PrivateInvitationsListView extends StatefulWidget {
  @override
  State<PrivateInvitationsListView> createState() => _PrivateInvitationsListViewState();
}

class _PrivateInvitationsListViewState extends State<PrivateInvitationsListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInvitationsByInvitee(
        GetIt.instance<AppState>().currentUserID!),
      builder: (BuildContext context, AsyncSnapshot<List<Invitation>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return SizedBox();
        }

        final List<Widget> widgets = [
          gapH80,
          AppDialogCategoryHeader(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: AppFontSizes.s20,
            fontWeight: FontWeight.w500,
            text: LandingPageText.privateInvitations,
          ),
        ];

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          widgets.addAll([
            gapH10,
            SizedBox(
              height: AppHeights.h250,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return LandingPageInvitationTile(
                    invitation: snapshot.data![index],
                    setStateCallback: () => setState(() {}),
                  );
                }
              )
            )
          ]);
        } else if (snapshot.hasError) {
          widgets.addAll([
            gapH50,
            Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            )
          ]);
        } else {
          widgets.addAll([
            gapH50,
            Center(child: CircularProgressIndicator())
          ]);
        }

        return Column(children: widgets,);
      }
    );
  }
}

class OpenInvitationCodeTextField extends StatefulWidget {
  @override
  State<OpenInvitationCodeTextField> createState() => _OpenInvitationCodeTextFieldState();
}

class _OpenInvitationCodeTextFieldState extends State<OpenInvitationCodeTextField> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(String gardenName) {
    setState(() {
      _controller.text = "";
    });

    final snackBar = AppSnackBars.getSnackBar(
      SnackBarText.validInvitationUUID,
      boldMessage: gardenName,
      duration: AppDurations.s9,
      showCloseIcon: true,
      snackbarType: SnackbarType.success
    );

    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _error(String errorMessage) {
    setState(() {
      _errorText = errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final validateUUIDButton = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => validateInvitationUUIDAndCreateUserGardenRecord(
            _controller.text,
            successCallback: _showSuccessSnackBar,
            errorCallback: _error
          ),
          icon: const Icon(Icons.arrow_forward)
        ),
        gapW5,
      ],
    );

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: AppStyles.textFieldBorder,
        enabledBorder: AppStyles.textFieldBorder,
        errorText: _errorText,
        floatingLabelStyle: AppStyles.floatingLabelStyle,
        focusedBorder: AppStyles.textFieldFocusedBorder,
        focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
        suffixIcon: validateUUIDButton
      ),
    );
  }
}