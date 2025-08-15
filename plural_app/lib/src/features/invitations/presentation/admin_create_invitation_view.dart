import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/fields.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/forms.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class AdminCreateInvitationView extends StatefulWidget {
  @override
  State<AdminCreateInvitationView> createState() => _AdminCreateInvitationViewState();
}

class _AdminCreateInvitationViewState extends State<AdminCreateInvitationView> {
  late AppDialogViewRouter _appDialogViewRouter;
  late AppForm _appForm;
  late AppState _appState;
  late GlobalKey<FormState> _formKey;

  InvitationType _initialInvitationTypeSelection = InvitationType.private;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();
    _appState = GetIt.instance<AppState>();
    _formKey = GlobalKey<FormState>();

    _controller.text = _initialInvitationTypeSelection.displayName;

    _appForm = AppForm.fromMap(Invitation.emptyMap())
      ..setValue(
          fieldName: InvitationField.creator,
          value: _appState.currentUserID)
      ..setValue(
          fieldName: InvitationField.garden,
          value: _appState.currentGarden!.id)
      ..setValue(
        fieldName: InvitationField.type,
        value: _initialInvitationTypeSelection.name)
      ..setValue(
        fieldName: AppFormFields.rebuild,
        value: () { setState(() {}); },
        isAux: true);
  }

  void setInvitationType(InvitationType? type) {
    setState(() {
      _controller.text = type!.displayName;
      _appForm.setValue(fieldName: InvitationField.type, value: type.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH50,
                    InvitationTypeDropdownMenu(
                      callback: setInvitationType,
                      controller: _controller,
                      initialSelection: _initialInvitationTypeSelection,
                      label: AdminInvitationViewText.type
                    ),
                    _controller.text == InvitationType.private.displayName ? // use controller.text instead of _appForm.getValue
                      AppTextFormField(
                        appForm: _appForm,
                        fieldName: InvitationField.invitee,
                        label: AdminInvitationViewText.invitee,
                        paddingBottom: AppPaddings.p0,
                      ) :
                      SizedBox(),
                    AppDatePickerFormField(
                      appForm: _appForm,
                      fieldName: InvitationField.expiryDate,
                      label: AdminInvitationViewText.expiryDate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              callback: _appDialogViewRouter.routeToAdminOptionsView,
              icon: Icons.arrow_back,
              message: AdminInvitationViewText.returnToAdminOptions,
            ),
            AppDialogFooterBufferSubmitButton(
              callback: submitCreate,
              positionalArguments: [context, _formKey, _appForm],
            ),
            RouteToViewButton(
              actionCallback: _appDialogViewRouter.routeToAdminListedInvitationsView,
              icon: Icons.outbox,
              message: AdminInvitationViewText.goToActiveInvitations,
            ),
          ]
        ),
        AppDialogFooter(title: AppDialogFooterText.adminCreateInvitation)
      ],
    );
  }
}

class InvitationTypeDropdownMenu extends StatelessWidget {
  const InvitationTypeDropdownMenu({
    required this.callback,
    required this.controller,
    required this.initialSelection,
    required this.label,
  });

  final void Function(InvitationType?) callback;
  final TextEditingController controller;
  final InvitationType initialSelection;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<InvitationType>(
      controller: controller,
      initialSelection: initialSelection,
      label: Text(label),
      onSelected: (InvitationType? type) => callback(type),
      requestFocusOnTap: false,
      dropdownMenuEntries: InvitationType.entries
    );
  }
}