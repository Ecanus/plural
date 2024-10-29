import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Routing
import 'package:plural_app/src/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter router = AppRouter().router;

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp.router(
        //theme: ThemeData.dark(),
        title: "Plural App",
        routerConfig: router,
      )
    );
  }
}

class AppState extends ChangeNotifier {

}
