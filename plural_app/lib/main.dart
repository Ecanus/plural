import 'package:flutter/material.dart';
import 'package:plural_app/src/app.dart';

// Service Locator
import 'package:plural_app/src/utils/service_locator.dart';

void main() {
  logIn(usernameOrEmail: "testuser2", password: "pickles2");
  createGetItInstances();
  runApp(MyApp());
}