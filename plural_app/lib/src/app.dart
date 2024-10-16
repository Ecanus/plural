import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_footer.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Plural App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: AppHomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {

}

class AppHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            gapH60,
            Row(
              children: [
                flex2,
                GardenHeader(),
                flex2,
              ],
            ),
            gapH30,
            Expanded(
              child: Row(
                children: [GardenTimeline()],
              )
            ),
            Row(
              children: [Expanded(child: GardenFooter())],
            ),
            gapH35
          ],
        ),
      ),
    );
  }
}