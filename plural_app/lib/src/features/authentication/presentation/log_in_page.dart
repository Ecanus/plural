import 'package:flutter/material.dart';

// Common Methods
import 'package:plural_app/src/common_methods/form_validators.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/forms.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
  });

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late GlobalKey<FormState> _formKey;
  late Map _loginMap;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _loginMap = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(
            width: AppConstraints.c350,
            height: AppConstraints.c350,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                  fieldName: LogInField.usernameOrEmail,
                  label: Labels.usernameOrEmail,
                  maxLength: AppMaxLengthValues.max50,
                  modelMap: _loginMap,
                  paddingBottom: AppPaddings.p5,
                  paddingTop: AppPaddings.p5,
                  validator: validateUsernameOrEmail,
                ),
                AppTextFormField(
                  fieldName: LogInField.password,
                  label: Labels.password,
                  maxLength: AppMaxLengthValues.max50,
                  modelMap: _loginMap,
                  paddingBottom: AppPaddings.p5,
                  paddingTop: AppPaddings.p5,
                ),
                ElevatedButton(
                  onPressed: () => submitLogIn(context, _formKey, _loginMap),
                  child: Text(Labels.login))
              ],
            ),
          ),
        )
      )
    );
  }
}