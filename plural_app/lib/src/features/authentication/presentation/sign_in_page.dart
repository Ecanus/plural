import 'package:flutter/material.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';
import 'package:plural_app/src/common_widgets/app_logo.dart';

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

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  late GlobalKey<FormState> _formKey;

  late TabController _tabController;

  late AppForm _appForm;
  late List<Tab> _tabs;

  @override
  void dispose() {
    _tabController.removeListener(_clearAppFormErrors);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    // Tabs
    _tabs = <Tab>[
      Tab(text: SignInLabels.logIn),
      Tab(text: SignInLabels.signUp),
    ];

    // Tab Controller
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_clearAppFormErrors);

    // AppForm
    _appForm = AppForm();
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () {setState( () {}); }
    );
  }

  void _clearAppFormErrors() {
    setState(() {
      _appForm.clearErrors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(
            width: AppConstraints.c500,
            height: AppConstraints.c800,
          ),
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  controller: _tabController,
                  tabs: _tabs),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  LogInTab(
                    formKey: _formKey,
                    appForm: _appForm
                  ),
                  SignUpTab(
                    formKey: _formKey,
                    appForm: _appForm
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: MediaQuery.sizeOf(context).height > AppHeights.h500 ?
        AppLogo()
        : null,
    );
  }
}
