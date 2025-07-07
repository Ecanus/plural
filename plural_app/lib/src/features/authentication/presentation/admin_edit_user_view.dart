import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_user_garden_role_picker_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/forms.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/presentation/expel_user_button.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

class AdminEditUserView extends StatefulWidget {
  const AdminEditUserView({
    required this.userGardenRecord,
  });

  final AppUserGardenRecord userGardenRecord;

  @override
  State<AdminEditUserView> createState() => _AdminEditUserViewState();
}

class _AdminEditUserViewState extends State<AdminEditUserView> {
  late AppForm _appForm;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _appForm = AppForm.fromMap(widget.userGardenRecord.toMap());
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); },
      isAux: true,
    );

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
      GetIt.instance<AppState>().currentUser! == widget.userGardenRecord.user;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    gapH15,
                    SelectableText(
                      widget.userGardenRecord.user.username,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    gapH50,
                    AppUserGardenRolePickerFormField(
                      appForm: _appForm,
                      fieldName: UserGardenRecordField.role,
                      initialValue: widget.userGardenRecord.role.displayName,
                      label: AdminListedUsersViewText.userGardenRole,
                    ),
                    gapH80,
                    isCurrentUser ?
                      SizedBox()
                      : ExpelUserButton(userGardenRecord: widget.userGardenRecord),
                  ],
                )
              ),
            ],
          ),
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToListedUsersViewButton(),
            AppDialogFooterBufferSubmitButton(
              callback: submitUpdateUserGardenRecord,
              positionalArguments: [context, _formKey, _appForm],
            ),
          ]
        ),
        AppDialogFooter(title: AppDialogFooterText.adminEditUser)
      ]
    );
  }
}

class RouteToListedUsersViewButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Tooltip(
      message: AppDialogFooterBufferText.adminListedUsersTooltip,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
        ),
        onPressed: () => appDialogViewRouter.routeToAdminListedUsersView(),
        child: const Icon(Icons.arrow_back)
      ),
    );
  }
}