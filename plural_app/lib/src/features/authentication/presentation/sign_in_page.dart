import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Classes
import 'package:plural_app/src/utils/app_form.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_logo.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/fields.dart';

// Authentication
import 'package:plural_app/src/features/authentication/presentation/log_in_tab.dart';
import 'package:plural_app/src/features/authentication/presentation/sign_up_tab.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    this.database, // primarily for testing
  });

  final PocketBase? database;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  late AppForm _appForm;
  late GlobalKey<FormState> _formKey;
  late List<Tab> _tabs;
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.removeListener(_clearAppFormErrors);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // AppForm
    _appForm = AppForm();
    _appForm.setValue(
      fieldName: AppFormFields.rebuild,
      value: () {setState( () {}); },
      isAux: true
    );

    // FormKey
    _formKey = GlobalKey<FormState>();

    // Tabs
    _tabs = <Tab>[
      Tab(text: SignInPageText.logIn),
      Tab(text: SignInPageText.signUp),
    ];

    // Tab Controller
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_clearAppFormErrors);
    _appForm.setValue(
      fieldName: AppFormFields.tabController,
      value: _tabController,
      isAux: true,
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
                  tabs: _tabs
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  LogInTab(
                    appForm: _appForm,
                    database: widget.database,
                    formKey: _formKey,
                  ),
                  SignUpTab(
                    appForm: _appForm,
                    database: widget.database,
                    formKey: _formKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: MediaQuery.sizeOf(context).height > AppHeights.h800 ?
        AppLogo()
        : null,
    );
  }
}
