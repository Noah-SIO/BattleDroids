import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() { //permet le lancement de l'application
  runApp(MyApp());
}

class MyApp extends StatelessWidget { //definie les nom,theme et extends widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), //couleur du theme
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //intégrité app, definie les données, extends changeNotifier
  var current = WordPair.random();// informe les autres widget

  void getNext() {
    current = WordPair.random(); //text aléatoire
    notifyListeners(); //informe toutes personnes
  }


  var favorites = <WordPair>[]; //liste vide pair de mot

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current); //supprime de la liste
    } else {
      favorites.add(current); //ajoute dans la liste
    }
    notifyListeners();
  }

}







class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) { //methode build obligatoire pour le mettre a jour
    
        Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold( //widget de premier niveau
          body: Row(
            children: [
              SafeArea( //s'assure que le widget n'est pas masquer
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite), //audiotrack,beach_access
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //watch suit modification de l'état app
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column( //nombre illimité d'enfant et les place en colonne de haut en bas, défaut enfant en haut
        mainAxisAlignment: MainAxisAlignment.center, //centrer en hauteur
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10), //séparation visuelle
          Row(
            mainAxisSize: MainAxisSize.min, //empeche d'utiliser tout l'espace
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton( //ajout d'un button
                onPressed: () {
                  appState.getNext(); //appel la methode getNext quand presser
                  print('button pressed!'); //console button pressed
                },
                child: Text('Next'), //text du button
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...



class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //theme  
    
    final style = theme.textTheme.displayMedium!.copyWith( //style taille
      color: theme.colorScheme.onPrimary, //couleur adapté au fond
    );

    return Card( //encadrement
    color: theme.colorScheme.primary, //une couleur
      child: Padding(
        padding: const EdgeInsets.all(20), //marge
        child: Text(
        pair.asLowerCase,
        semanticsLabel: "${pair.first} ${pair.second}", 
        style: style), //mon text et style
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}