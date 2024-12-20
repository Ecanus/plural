import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/common_classes/app_form.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Authentication
import 'package:plural_app/src/features/authentication/presentation/log_in_tab.dart';
import 'package:plural_app/src/features/authentication/presentation/sign_up_tab.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late GlobalKey<FormState> _formKey;

  late AppForm _appForm;
  late List<Tab> _tabs;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    // Tabs
    _tabs = <Tab>[
      Tab(text: SignInLabels.login),
      Tab(text: SignInLabels.signup),
    ];

    // AppForm
    _appForm = AppForm();
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () {setState(() {});}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(
            width: AppConstraints.c500,
            height: AppConstraints.c500,
          ),
          child: Form(
            key: _formKey,
            child: DefaultTabController(
              length: _tabs.length,
              child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(tabs: _tabs),
                ),
                body: TabBarView(
                  children: [
                    LogInTab(
                      formKey: _formKey,
                      appForm: _appForm),
                    SignUpTab(
                      formKey: _formKey,
                      appForm: _appForm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
