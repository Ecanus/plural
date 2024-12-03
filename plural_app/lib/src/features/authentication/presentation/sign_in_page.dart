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
            width: AppConstraints.c450,
            height: AppConstraints.c450
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
                    LogInWidget(
                      formKey: _formKey,
                      logInMap: _formMap),
                    Center(child: Text("This is the Sign Up"),),
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

class LogInWidget extends StatelessWidget {
  const LogInWidget({
    super.key,
    required this.formKey,
    required this.logInMap,
  });

  final GlobalKey<FormState> formKey;
  final Map logInMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p50),
      child: Column(
        children: [
          AppTextFormField(
            fieldName: LogInField.usernameOrEmail,
            label: Labels.email,
            maxLength: AppMaxLengthValues.max50,
            modelMap: logInMap,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
            validator: validateUsernameOrEmail,
          ),
          AppTextFormField(
            fieldName: LogInField.password,
            isPassword: true,
            label: Labels.password,
            maxLength: AppMaxLengthValues.max50,
            modelMap: logInMap,
            paddingBottom: AppPaddings.p5,
            paddingTop: AppPaddings.p5,
          ),
          gapH30,
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
            onPressed: () => submitLogIn(context, formKey, logInMap),
            style: IconButton.styleFrom(backgroundColor: Colors.black),
            tooltip: Strings.loginTooltip,
          ),
        ],
      ),
    );
  }
}