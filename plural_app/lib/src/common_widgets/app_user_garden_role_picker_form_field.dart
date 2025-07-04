import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/styles.dart';
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/utils/app_state.dart';

class AppUserGardenRolePickerFormField extends StatefulWidget {
  const AppUserGardenRolePickerFormField({
    required this.appForm,
    required this.fieldName,
    required this.initialValue,
    this.label = "",
  });

  final AppForm appForm;
  final String fieldName;
  final String initialValue;
  final String label;

  @override
  State<AppUserGardenRolePickerFormField> createState() => _AppUserGardenRolePickerFormFieldState();
}

class _AppUserGardenRolePickerFormFieldState extends State<AppUserGardenRolePickerFormField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.text = widget.initialValue;
  }

  void _setControllerText(AppUserGardenRole newRole) {
    setState(() { _controller.text = newRole.displayName; });
  }

  @override
  Widget build(BuildContext context) {
    var showDialogButton = IconButton(
      onPressed: () => showRolePickerDialog(
        context,
        _setControllerText,
      ),
      icon: const Icon(Icons.mode_edit_outlined),
    );

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              border: AppStyles.textFieldBorder,
              enabledBorder: AppStyles.textFieldBorder,
              errorText: widget.appForm.getError(fieldName: widget.fieldName),
              floatingLabelStyle: AppStyles.floatingLabelStyle,
              focusedBorder: AppStyles.textFieldFocusedBorder,
              focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
              label: Text(widget.label),
            ),
            enabled: false,
            onSaved: (value) => widget.appForm.save(
              fieldName: widget.fieldName,
              value: getUserGardenRoleFromString(value!, displayName: true)?.name,
              formFieldType: FormFieldType.text,
            ),
            validator: (value) => validateUserGardenRole(
              getUserGardenRoleFromString(value!, displayName: true)?.name
            )
          ),
        ),
        gapW10,
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: showDialogButton,
        )
      ],
    );
  }
}

Future<void> showRolePickerDialog(
  BuildContext context,
  void Function(AppUserGardenRole) setTextCallback,
) async {
  final AppUserGardenRole? role = await showDialog<AppUserGardenRole>(
    context: context,
    builder: (BuildContext context) {
      return UserGardenRolePickerDialog();
    }
  );

  if (role != null) setTextCallback(role);
}

Future<List<UserGardenRoleCard>> getUserGardenRoleCards() async {
  final isAdministrator = await GetIt.instance<AppState>().isAdministrator();
  final isOwner = await GetIt.instance<AppState>().isOwner();

  final roles = [
    AppUserGardenRole.administrator,
    AppUserGardenRole.member,
  ];

  if (isOwner) {
    roles.insert(0, AppUserGardenRole.owner);
    return [for (var role in roles) UserGardenRoleCard(role: role)];
  }
  if (isAdministrator) {
    return [for (var role in roles) UserGardenRoleCard(role: role)];
  }

  return [];
}

class UserGardenRolePickerDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(),
      child: Container(
        padding: const EdgeInsets.only(
          top: AppPaddings.p50,
          bottom: AppPaddings.p20,
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c400,
          height: AppConstraints.c600,
        ),
        child: Column(
          children: [
            FutureBuilder(
              future: getUserGardenRoleCards(),
              builder: (BuildContext context, AsyncSnapshot<List<UserGardenRoleCard>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPaddings.p15,
                      ),
                      children: snapshot.data!,
                    )
                  );
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(child: Text(snapshot.error.toString()))
                  );
                } else {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }
              }
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ),
    );
  }
}

class UserGardenRoleCard extends StatelessWidget {
  const UserGardenRoleCard({
    required this.role,
  });

  final AppUserGardenRole role;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(),
      elevation: AppElevations.e5,
      child: ListTile(
        onTap: () => Navigator.pop(context, role),
        tileColor: Theme.of(context).colorScheme.secondaryFixed,
        title: Text(role.displayName),
      ),
    );
  }
}