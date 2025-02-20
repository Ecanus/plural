import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Routing
import 'package:plural_app/src/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().router,
      theme: AppThemes.standard,
      title: AppText.pluralApp,
    );
  }
}
