import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
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

class MyAppState extends ChangeNotifier {
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

  void removeFavorite() {

  }

}

class PluralAppHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.green,
                    // child: Text("green"),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Text(
                          "Hi, Dedie",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                      ),
                      Text(
                          "2024.09.03",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                      ),
                      gapH20
                    ],
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.blue,
                    // child: Text("blue"),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  PluralAppTimeline(),
                ],
              )
              ),
            Row(
              children: [
                Expanded(
                  child: _PluralBottomAppBar()
                ),
              ],
            ),
            gapH35
          ],
        ),
      ),
    );
  }
}

class PluralAppTimeline extends StatelessWidget {

  final testChild1 = PluralAppViewableTimelineTile(
    tileDate: "2024.09.04",
    tileTimeRemaining: "16 hours left",
    tileText: "Need help with groceries this week. Anything helps. appreciate yall!",
  );

  final testChild2 = PluralAppViewableTimelineTile(
    tileDate: "2024.09.16",
    tileTimeRemaining: "13 days left",
    tileText: "Dropped my phone last night :( dammit",
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
        padding: const EdgeInsets.all(8),
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
    required this.tileText
  });

  final String tileDate;
  final String tileTimeRemaining;
  final String tileText;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: const IndicatorStyle(
        width: PluralAppTimelineValues.indicatorWidth,
        color: PluralAppTimelineValues.mainColor,
      ),
      beforeLineStyle: const LineStyle(
        color: PluralAppTimelineValues.mainColor,
        thickness: PluralAppTimelineValues.timelineThickness,
      ),
      startChild: GestureDetector(
        onTap: () => dialogBuilder(context),
        child: PluralAppBaseTimelineTile(
          tileDate: tileDate,
          tileTimeRemaining: tileTimeRemaining,
          tileText: tileText,
          alignment: Alignment.centerRight,
        ),
      ),
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
      indicatorStyle: const IndicatorStyle(
        width: PluralAppTimelineValues.indicatorWidth,
        color: PluralAppTimelineValues.mainColor,
      ),
      beforeLineStyle: const LineStyle(
        color: PluralAppTimelineValues.mainColor,
        thickness: PluralAppTimelineValues.timelineThickness,
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
          color: Colors.white,
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
                      children: getTimelineTileFooterChildren(isViewable)
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

  List<Widget> getTimelineTileFooterChildren(bool isViewable) {
    List<Widget> widgets = [];

    Widget button = OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0)),
        ),
      ),
      child: Text("Groceries"),
    );

    Widget icon = Icon(
      Icons.arrow_drop_down_circle_rounded,
      color: Colors.grey,
    );

    if (isViewable) {
      widgets.add(button);
      widgets.add(gapW15);
      widgets.add(icon);
    } else {
      widgets.add(button);
    }

    return widgets;
  }
}

// class _ComponentRow extends StatelessWidget {
//   const _ComponentRow({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TimelineTile(
//       node: TimelineNode.simple(),
//       contents: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           elevation: 5.0,
//           padding: const EdgeInsets.all(15.0),
//           shape: CircleBorder(),
//         ),
//         onPressed: () => _dialogBuilder(context),
//         child: Icon(
//           Icons.edit,
//         )
//       ),
//       oppositeContents: SizedBox(
//         height: 185.0,
//         width: 300.0,
//         child: GestureDetector(
//           onTap: () => _dialogBuilder(context),
//           child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text("2024.09.13"),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         "10 days left",
//                         style: TextStyle(fontWeight: FontWeight.bold)
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 25
//                   ),
//                   Wrap(
//                     runSpacing: 20.0,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                             Flexible(
//                               child: Text(
//                                 "Need help with veggies and fruits this week hiii :(",
//                                 textAlign: TextAlign.end,
//                               ),
//                             ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                             OutlinedButton(
//                               onPressed: null,
//                               child: Text("Groceries"),
//                             ),
//                             Icon(Icons.arrow_drop_down_rounded),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             ),
//         ),
//       ),
//       );
//   }

//   Future _dialogBuilder(BuildContext context) {
//       return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return SimpleDialog(
//             title: Text("Dialog Title"),
//             children: [
//               SimpleDialogOption(
//                 onPressed: () { Navigator.of(context).pop(); },
//                 child: Text("Click to close"),
//               )
//             ],
//           );
//         });
//   }
// }

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

class _PluralBottomAppBar extends StatelessWidget {
  // Icons
  final _iconColor = Colors.white;
  final _iconBackgroundColor = Colors.black;
  final _iconButtonIconSize = 31.0;

  // Container
  final _containerColor = const Color.fromARGB(255, 51, 51, 51);
  final _widthConstraint = 350.0;
  final _heightConstraint = 50.0;
  final _borderRadius = 50.0;
  final _emptySizedBoxWidth = 10.0;

  // Elevated Button
  final _elevatedButtonLeftPosition = -10.0;
  final _elevatedButtonElevation = 5.0;
  final _elevatedButtonPadding = 18.0;
  static const _elevatedButtonIconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: _widthConstraint,
              height: _heightConstraint
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: _containerColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: _emptySizedBoxWidth,
                ),
                IconButton(
                  color: _iconColor,
                  icon: const Icon(Icons.library_add),
                  iconSize: _iconButtonIconSize,
                  tooltip: "Add Ask",
                  onPressed: () {},
                ),
                IconButton(
                  color: _iconColor,
                  icon: const Icon(Icons.settings),
                  iconSize: _iconButtonIconSize,
                  tooltip: "Settings",
                  onPressed: () {},
                ),
                IconButton(
                  color: _iconColor,
                  icon: const Icon(Icons.mail),
                  iconSize: _iconButtonIconSize,
                  tooltip: "Invitations",
                  onPressed: () {},
                ),
                IconButton(
                  color: _iconColor,
                  icon: const Icon(Icons.grass),
                  iconSize: _iconButtonIconSize,
                  tooltip: "Add Garden",
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: _elevatedButtonLeftPosition,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _iconBackgroundColor,
                elevation: _elevatedButtonElevation,
                iconColor: _iconColor,
                padding: EdgeInsets.all(_elevatedButtonPadding),
                shape: CircleBorder(),
              ),
              onPressed: () {},
              child: const Icon(
                Icons.close,
                size: _elevatedButtonIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
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


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${favorites.length} favorites saved:'),
        ),
        for (var favorite in favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(favorite.asLowerCase),
      ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}