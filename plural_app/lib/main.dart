import 'package:flutter/material.dart';
import 'package:plural_app/src/app.dart';

import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

void main() async{
  await login("user2@test.com", "pickles2");
  runApp(MyApp());
}