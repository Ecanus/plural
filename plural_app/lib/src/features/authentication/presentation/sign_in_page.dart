import 'package:flutter/material.dart';

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

  late Map _formMap;
  late List<Tab> _tabs;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    // Tabs
    _tabs = <Tab>[
      Tab(text: Labels.login),
      Tab(text: Labels.signup),
    ];

    // Map
    _formMap = {
      ModelMapKeys.errorTextKey: null,
      ModelMapKeys.rebuildKey: () {setState(() {});},
    };
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
                      logInMap: _formMap),
                    SignUpTab(
                      formKey: _formKey,
                      signUpMap: _formMap),
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
