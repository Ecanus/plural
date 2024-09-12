import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
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

  final children = [
    SizedBox(
      height: 25,
      child: SolidLineConnector(),
    ),
    _ComponentRow(),
    SizedBox(
      height: 50,
      child: SolidLineConnector(),
    ),
    _ComponentRow(),
    SizedBox(
      height: 50,
      child: SolidLineConnector(),
    ),
    _ComponentRow(),
    SizedBox(
      height: 25,
      child: SolidLineConnector(),
    ),
  ];


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
                    color: Colors.green,
                    child: Text("green"),
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
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.blue,
                    child: Text("blue"),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: children,
                    ),
                  ),
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
            SizedBox(
              height: 35,
            )
          ],
        ),
      ),
    );
  }
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      node: TimelineNode.simple(),
      contents: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
        onPressed: () => _dialogBuilder(context),
        child: Icon(
          Icons.edit,
        )
      ),
      oppositeContents: SizedBox(
        height: 185.0,
        width: 300.0,
        child: GestureDetector(
          onTap: () => _dialogBuilder(context),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("2024.09.13"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "10 days left",
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25
                  ),
                  Wrap(
                    runSpacing: 20.0,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            Flexible(
                              child: Text(
                                "Need help with veggies and fruits this week hiii :(",
                                textAlign: TextAlign.end,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            OutlinedButton(
                              onPressed: null,
                              child: Text("Groceries"),
                            ),
                            Icon(Icons.arrow_drop_down_rounded),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
        ),
      ),
      );
  }

  Future _dialogBuilder(BuildContext context) {
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
        });
  }
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