import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/forms.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox()
    );
  }
}

class TestLogin extends StatelessWidget {
  TestLogin({
    required this.appForm,
    required this.fieldName,
    required this.formKey,
    this.validatorReturnVal,
  });

  final AppForm appForm;
  final String fieldName;
  final GlobalKey<FormState> formKey;
  final String? validatorReturnVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            child: ListView(
              children: [
                TextFormField(
                  onSaved: (value) => appForm.save(
                    fieldName: fieldName,
                    value: "New Settings Value!",
                  ),
                  validator: (value) => validatorReturnVal,
                ),
                ElevatedButton(
                  onPressed: () => submitLogIn(context, formKey, appForm),
                  child: Text("x")
                ),
              ],
            ),
          );
        }
      )
    );
  }
}

class TestTabView extends StatefulWidget {
  TestTabView({
    required this.appForm,
    required this.fieldName,
    required this.formKey,
    required this.pb,
    this.validatorReturnVal,
  });

  final AppForm appForm;
  final String fieldName;
  final GlobalKey<FormState> formKey;
  final PocketBase pb;
  final String? validatorReturnVal;

  @override
  State<TestTabView> createState() => _TestTabViewState();
}

class _TestTabViewState extends State<TestTabView> with SingleTickerProviderStateMixin {
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    // Tabs
    _tabs = <Widget>[
      BlankPage(),
      TestSignUpTab(
        appForm: widget.appForm,
        fieldName: widget.fieldName,
        formKey: widget.formKey,
        pb: widget.pb,
        validatorReturnVal: widget.validatorReturnVal,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: widget.formKey,
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text("Tab View")
                    ),
                    body: DefaultTabController(
                      initialIndex: 1,
                      length: _tabs.length,
                      child: TabBar(tabs: _tabs),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestSignUpTab extends StatelessWidget {
  TestSignUpTab({
    required this.appForm,
    required this.fieldName,
    required this.formKey,
    required this.pb,
    this.validatorReturnVal,
  });

  final AppForm appForm;
  final String fieldName;
  final GlobalKey<FormState> formKey;
  final PocketBase pb;
  final String? validatorReturnVal;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          onSaved: (value) => appForm.save(
            fieldName: fieldName,
            value: "New TestSignUp Value!",
          ),
          validator: (value) => validatorReturnVal,
        ),
        ElevatedButton(
          onPressed: () => submitSignUp(context, formKey, appForm, database: pb),
          child: Text("x")
        ),
      ],
    );
  }
}