import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/routes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/forms.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

Future createAdminCurrentGardenSettingsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(view: AdminCurrentGardenSettingsView());
    }
  );
}

class AdminCurrentGardenSettingsView extends StatefulWidget {
  @override
  State<AdminCurrentGardenSettingsView> createState() =>
    _AdminCurrentGardenSettingsViewState();
}

class _AdminCurrentGardenSettingsViewState extends State<AdminCurrentGardenSettingsView> {
  late AppForm _appForm;
  late Garden _currentGarden;
  late GlobalKey<FormState> _formKey;

  AppDialogViewRouter _appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

  @override
  void initState() {
    super.initState();

    _currentGarden = GetIt.instance<AppState>().currentGarden!;

    _appForm = AppForm.fromMap(_currentGarden.toMap());
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () { setState(() {}); },
      isAux: true,
    );

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.p35,
            right: AppPaddings.p35,
            top: AppPaddings.p50,
            bottom: AppPaddings.p10,
          ),
          child: Column(
            children: [
              GoToCurrentGardenPageTile(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      appForm: _appForm,
                      fieldName: GardenField.name,
                      initialValue: _currentGarden.name,
                      label: AdminCurrentGardenSettingsViewText.name,
                    ),
                  ],
                )
              ),
            ],
          )
        ),
        AppDialogFooterBuffer(
          buttons: [
            AppDialogFooterBufferSubmitButton(
              callback: submitUpdate,
              positionalArguments: [context, _formKey, _appForm],
            ),
          ]
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.people_alt,
          leftNavActionCallback: _appDialogViewRouter.routeToAdminListedUsersView,
          leftTooltipMessage: AppDialogFooterText.navToAdminListedUsers,
          rightDialogIcon: Icons.security,
          rightNavCallback: _appDialogViewRouter.routeToAdminOptionsView,
          rightTooltipMessage: AppDialogFooterText.navToAdminOptions,
          title: AppDialogFooterText.adminGardenSettings
        )
      ],
    );
  }
}

class GoToCurrentGardenPageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          AdminCurrentGardenSettingsViewText.returnToGardenPage,
          style: TextStyle(
            fontWeight: FontWeight.w500)
        ),
        leading: Icon(Icons.local_florist),
        onTap: () => GoRouter.of(context).go(Routes.garden)
      ),
    );
  }
}