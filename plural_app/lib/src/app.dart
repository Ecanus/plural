import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PluralAppState(),
      child: MaterialApp(
        title: 'Plural App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: PluralAppHomePage(),
      ),
    );
  }
}

class PluralAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class PluralAppHomePage extends StatelessWidget {
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
                PluralAppHeader(),
                flex2,
              ],
            ),
            gapH30,
            Expanded(
              child: Row(
                children: [PluralAppTimeline()],
              )
            ),
            Row(
              //children: [Expanded(child: PluralAppBottomBar())],
              //children: [Expanded(child: PluralAppBottomButton())],
              children: [Expanded(child: PluralAppFooter())],
            ),
            gapH35
          ],
        ),
      ),
    );
  }
}

class PluralAppHeader extends StatelessWidget {
  const PluralAppHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: PluralAppFlexes.f6,
      child: Column(
        children: [
          Text(
              "Hi, Dedie",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: PluralAppFontSizes.s25,
              ),
              textAlign: TextAlign.center,
          ),
          Text(
              "2024.09.03",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
          ),
        ],
      )
    );
  }
}

class PluralAppTimeline extends StatelessWidget {

  final testChild1 = PluralAppViewableTimelineTile(
    tileDate: "2024.09.04",
    tileTimeRemaining: "16 hours left",
    tileText: "Need help with groceries this week. Anything helps. appreciate yall!",
    isSponsored: false,
  );

  final testChild2 = PluralAppViewableTimelineTile(
    tileDate: "2024.09.16",
    tileTimeRemaining: "13 days left",
    tileText: "Dropped my phone last night :( dammit",
    isSponsored: true,
  );

  final testChild3 = PluralAppEditableTimelineTile(
    tileDate: "2024.09.23",
    tileTimeRemaining: "20 days left",
    tileText: "Hey! my mom is sick and we can use help with meds",
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(PluralAppPaddings.p8),
        children: [
          testChild1,
          testChild2,
          testChild3,
        ],
      ),
    );
  }
}

class PluralAppViewableTimelineTile extends StatelessWidget {
  const PluralAppViewableTimelineTile({
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
      indicatorStyle: pluralAppIndicatorStyle,
      beforeLineStyle: pluralAppLineStyle,
      startChild: PluralAppBaseTimelineTile(
        tileDate: tileDate,
        tileTimeRemaining: tileTimeRemaining,
        tileText: tileText,
        alignment: Alignment.centerRight,
      ),
      endChild: isSponsored ? Container(
        padding: const EdgeInsets.all(PluralAppPaddings.p5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.check_circle,
            color: PluralAppColors.primaryColor,
            size: PluralAppIconSizes.s30
          ),
        ),
      ) : null,
    );
  }
}

class PluralAppEditableTimelineTile extends StatelessWidget {
  const PluralAppEditableTimelineTile({
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
      indicatorStyle: pluralAppIndicatorStyle,
      beforeLineStyle: pluralAppLineStyle,
      startChild: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: PluralAppElevations.e5,
            padding: const EdgeInsets.all(PluralAppPaddings.p15),
            shape: CircleBorder(),
            iconColor: PluralAppColors.secondaryColor,
            backgroundColor: PluralAppColors.primaryColor
          ),
          onPressed: () => dialogBuilder(context),
          child: Icon(Icons.edit)
        ),
      ),
      endChild: PluralAppBaseTimelineTile(
        tileDate: tileDate,
        tileTimeRemaining: tileTimeRemaining,
        tileText: tileText,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class PluralAppBaseTimelineTile extends StatelessWidget {
  const PluralAppBaseTimelineTile({
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
        padding: EdgeInsets.all(PluralAppPaddings.p10),
        constraints: BoxConstraints.expand(
          width: PluralAppConstraints.c375,
          height: PluralAppConstraints.c230,
        ),
        child: Card(
          elevation: PluralAppElevations.e7,
          color: PluralAppColors.secondaryColor,
          child: Padding(
            padding: EdgeInsets.all(PluralAppPaddings.p10),
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
                  runSpacing: PluralAppRunSpacings.rs20,
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
            Radius.circular(PluralAppBorderRadii.r5)),
        ),
      ),
      child: Text("Groceries"),
    );

    Widget button = SizedBox(
      width: PluralAppDimensions.d25,
      height: PluralAppDimensions.d25,
      child: IconButton(
        color: PluralAppColors.primaryColor,
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        padding: const EdgeInsets.all(PluralAppPaddings.p0),
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

class PluralAppFooter extends StatelessWidget {
  final ValueNotifier<bool> _isFooterCollapsed = ValueNotifier<bool>(true);

  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: PluralAppColors.onPrimaryColor,
    elevation: PluralAppElevations.e5,
    iconColor: PluralAppColors.secondaryColor,
    padding: EdgeInsets.all(PluralAppPaddings.p18),
    shape: CircleBorder(),
  );

  bool isFooterCollapsedCheck () {
    return _isFooterCollapsed.value = !_isFooterCollapsed.value;
  }

  @override
  Widget build(BuildContext context) {
    final showActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: isFooterCollapsedCheck,
      child: Icon(Icons.add, size: PluralAppIconSizes.s30),
    );

    final hideActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: isFooterCollapsedCheck,
      child: Icon(Icons.close, size: PluralAppIconSizes.s30),
    );

    return ValueListenableBuilder(
      valueListenable: _isFooterCollapsed,
      builder: (BuildContext context, bool value, Widget? child) {
        return value ?
          Center(child: showActionsButton) :
          PluralAppBottomBar(hideActionsButton: hideActionsButton,);
      }
    );
  }
}

class PluralAppBottomBar extends StatelessWidget {
  const PluralAppBottomBar({
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
              width: PluralAppConstraints.c350,
              height: PluralAppConstraints.c50
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PluralAppBorderRadii.r50),
              color: PluralAppColors.darkGrey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                gapW10,
                IconButton(
                  color: PluralAppColors.secondaryColor,
                  icon: const Icon(Icons.library_add),
                  iconSize: PluralAppButtonSizes.s31,
                  tooltip: Strings.tooltipAddAsk,
                  onPressed: () {},
                ),
                IconButton(
                  color: PluralAppColors.secondaryColor,
                  icon: const Icon(Icons.settings),
                  iconSize: PluralAppButtonSizes.s31,
                  tooltip: Strings.tooltipSettings,
                  onPressed: () {},
                ),
                IconButton(
                  color: PluralAppColors.secondaryColor,
                  icon: const Icon(Icons.mail),
                  iconSize: PluralAppButtonSizes.s31,
                  tooltip: Strings.tooltipInvitations,
                  onPressed: () {},
                ),
                IconButton(
                  color: PluralAppColors.secondaryColor,
                  icon: const Icon(Icons.grass),
                  iconSize: PluralAppButtonSizes.s31,
                  tooltip: Strings.tooltipAddGarden,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: PluralAppPositions.pNeg10,
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
        title: Text("Dialog Title"),
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