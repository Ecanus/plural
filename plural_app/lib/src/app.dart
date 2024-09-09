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
    TimelineTile(
      node: TimelineNode.simple(),
      oppositeContents: Card(
        child: Container(
          padding: const EdgeInsets.all(50.0),
          child: Text('Test Card Dedie'),
          ),
        ),
      ),
      TimelineTile(
        node: TimelineNode.simple(),
        oppositeContents: Card(
          child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Text('Test Card Dedie'),
            ),
        ),
      ),
      TimelineTile(
        node: TimelineNode.simple(),
        contents: Card(
          child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Text('Test Card Dedie'),
            ),
        ),
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
              )),
            Row(
              children: [
                Expanded(
                  child: _PluralBottomAppBar()
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class _PluralBottomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {},
              tooltip: "Close Menu",
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: CircleBorder(),
              child: const Icon(Icons.close),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.library_add),
              tooltip: "Add Ask",
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
              tooltip: "Settings",
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_rounded),
              tooltip: "Invite Users",
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.grass),
              tooltip: "Add Garden",
            ),
          ],
        ),
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