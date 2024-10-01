import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
//import 'package:english_words/english_words.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/ask_dialog.dart';

// Authentication
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

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
  AppUser testUser = AppUser(
    uid: "12345",
    email: "user@test.com",
    password: "testPASSWORD",
    firstName: "Akosua",
    lastName: "Dankye"
  );

  // void getNext() {
  //   current = WordPair.random();
  //   notifyListeners();
  // }

  // void toggleFavorite() {
  //   if (favorites.contains(current)) {
  //     favorites.remove(current);
  //   } else {
  //     favorites.add(current);
  //   }
  //   notifyListeners();
  // }
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
                children: [AppTimeline()],
              )
            ),
            Row(
              children: [Expanded(child: AppFooter())],
            ),
            gapH35
          ],
        ),
      ),
    );
  }
}

class AppTimeline extends StatelessWidget {

  final testChild1 = AppViewableTimelineTile(
    tileDate: "2024.09.04",
    tileTimeRemaining: "16 hours left",
    tileText: "Need help with groceries this week. Anything helps. appreciate yall!",
    isSponsored: false,
  );

  final testChild2 = AppViewableTimelineTile(
    tileDate: "2024.09.16",
    tileTimeRemaining: "13 days left",
    tileText: "Dropped my phone last night :( dammit",
    isSponsored: true,
  );

  final testChild3 = AppEditableTimelineTile(
    tileDate: "2024.09.23",
    tileTimeRemaining: "20 days left",
    tileText: "Hey! my mom is sick and we can use help with meds",
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(AppPaddings.p8),
        children: [
          testChild1,
          testChild2,
          testChild3,
        ],
      ),
    );
  }
}

class AppViewableTimelineTile extends StatelessWidget {
  const AppViewableTimelineTile({
    super.key,
    required this.tileDate,
    required this.tileTimeRemaining,
    required this.tileText,
    required this.isSponsored,
  });

  final String tileDate;
  final String tileTimeRemaining;
  final String tileText;
  final bool isSponsored;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: appLineStyle,
      startChild: AppBaseTimelineTile(
        tileDate: tileDate,
        tileTimeRemaining: tileTimeRemaining,
        tileText: tileText,
        alignment: Alignment.centerRight,
      ),
      endChild: isSponsored ? Container(
        padding: const EdgeInsets.all(AppPaddings.p5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.check_circle,
            color: AppColors.primaryColor,
            size: AppIconSizes.s30
          ),
        ),
      ) : null,
    );
  }
}

class AppEditableTimelineTile extends StatelessWidget {
  const AppEditableTimelineTile({
    super.key,
    required this.tileDate,
    required this.tileTimeRemaining,
    required this.tileText
  });

  final String tileDate;
  final String tileTimeRemaining;
  final String tileText;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: appIndicatorStyle,
      beforeLineStyle: appLineStyle,
      startChild: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: AppElevations.e5,
            padding: const EdgeInsets.all(AppPaddings.p15),
            shape: CircleBorder(),
            iconColor: AppColors.secondaryColor,
            backgroundColor: AppColors.primaryColor
          ),
          onPressed: () => dialogBuilder(context),
          child: Icon(Icons.edit)
        ),
      ),
      endChild: AppBaseTimelineTile(
        tileDate: tileDate,
        tileTimeRemaining: tileTimeRemaining,
        tileText: tileText,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class AppBaseTimelineTile extends StatelessWidget {
  const AppBaseTimelineTile({
    super.key,
    required this.tileDate,
    required this.tileTimeRemaining,
    required this.tileText,
    required this.alignment
  });

  final String tileDate;
  final String tileTimeRemaining;
  final String tileText;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    bool isViewable = alignment == Alignment.centerRight;

    final MainAxisAlignment axisAlignment =
       isViewable ? MainAxisAlignment.end : MainAxisAlignment.start;

    final TextAlign textAlignment =
      isViewable ? TextAlign.end : TextAlign.start;

    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.all(AppPaddings.p10),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c375,
          height: AppConstraints.c230,
        ),
        child: Card(
          elevation: AppElevations.e7,
          color: AppColors.secondaryColor,
          child: Padding(
            padding: EdgeInsets.all(AppPaddings.p10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: axisAlignment,
                  children: [
                    Text(tileDate),
                  ],
                ),
                Row(
                  mainAxisAlignment: axisAlignment,
                  children: [
                    Text(
                      tileTimeRemaining,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                gapH25,
                Wrap(
                  runSpacing: AppRunSpacings.rs20,
                  children: [
                    Row(
                      mainAxisAlignment: axisAlignment,
                      children: [
                        Flexible(
                          child: Text(
                            tileText,
                            textAlign: textAlignment,
                          ),
                        )
                      ]
                    ),
                    gapH60,
                    Row(
                      mainAxisAlignment: axisAlignment,
                      children: getTimelineTileFooterChildren(context, isViewable)
                    ),
                  ],
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTimelineTileFooterChildren(
    BuildContext context, bool isViewable) {
    List<Widget> widgets = [];

    Widget tag = OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppBorderRadii.r5)),
        ),
      ),
      child: Text("Groceries"),
    );

    Widget button = SizedBox(
      width: AppWidths.w25,
      height: AppHeights.h25,
      child: IconButton(
        color: AppColors.primaryColor,
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        padding: const EdgeInsets.all(AppPaddings.p0),
        onPressed: () => dialogBuilder(context),
      ),
    );

    if (isViewable) {
      widgets.add(tag);
      widgets.add(gapW15);
      widgets.add(button);
    } else {
      widgets.add(tag);
    }

    return widgets;
  }
}

/// Parent Widget of the AppBottomBar and all widgets
/// at the bottom of the App.
class AppFooter extends StatelessWidget {
  final ValueNotifier<bool> _isFooterCollapsed = ValueNotifier<bool>(true);

  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.onPrimaryColor,
    elevation: AppElevations.e5,
    iconColor: AppColors.secondaryColor,
    padding: EdgeInsets.all(AppPaddings.p18),
    shape: CircleBorder(),
  );

  bool toggleIsFooterCollapsed () {
    return _isFooterCollapsed.value = !_isFooterCollapsed.value;
  }

  @override
  Widget build(BuildContext context) {
    final showActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: toggleIsFooterCollapsed,
      child: Icon(Icons.add, size: AppIconSizes.s30),
    );

    final hideActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: toggleIsFooterCollapsed,
      child: Icon(Icons.close, size: AppIconSizes.s30),
    );

    return ValueListenableBuilder(
      valueListenable: _isFooterCollapsed,
      builder: (BuildContext context, bool value, Widget? child) {
        return value ?
          Center(child: showActionsButton) :
          AppBottomBar(hideActionsButton: hideActionsButton,);
      }
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.hideActionsButton
  });

  final Widget hideActionsButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c350,
              height: AppConstraints.c50
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadii.r50),
              color: AppColors.darkGrey1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                gapW10,
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.library_add),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipAddAsk,
                  onPressed: () => createAskDialogBuilder(context),
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.settings),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipSettings,
                  onPressed: () {},
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.mail),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipInvitations,
                  onPressed: () {},
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.grass),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipAddGarden,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: AppPositions.pNeg10,
            child: hideActionsButton,
          ),
        ],
      ),
    );
  }
}

Future dialogBuilder(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("TO REMOVE Dialog Title"),
        children: [
          SimpleDialogOption(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text("Click to close"),
          )
        ],
      );
    }
  );
}

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {

//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//       case 1:
//         page = FavoritesPage();
//       default:
//         throw UnimplementedError('no Widget for $selectedIndex');
//     }

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Scaffold(
//           body: Row(
//             children: [
//               SafeArea(
//                 child: NavigationRail(
//                   extended: constraints.maxWidth >= 600,
//                   destinations: [
//                     NavigationRailDestination(
//                       icon: Icon(Icons.home),
//                       label: Text('Home'),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.favorite),
//                       label: Text('Favorites'),
//                     ),
//                   ],
//                   selectedIndex: selectedIndex,
//                   onDestinationSelected: (value) {

//                     setState(() {
//                       selectedIndex = value;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   child: page,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     );
//   }
// }


// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var favorites = appState.favorites;

//     if (appState.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have ${favorites.length} favorites saved:'),
//         ),
//         for (var favorite in favorites)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(favorite.asLowerCase),
//       ),
//       ],
//     );
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );

//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: "${pair.first} ${pair.second}",
//         ),
//       ),
//     );
//   }
// }