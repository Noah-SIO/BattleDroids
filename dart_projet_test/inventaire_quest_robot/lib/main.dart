import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async{
  //database

    // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'inventory_database.db'),
    onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE objet(id INTEGER PRIMARY KEY, nom TEXT, poids INTEGER)',
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
  );


  //var objet1 = Objet(1,'Kebab', 15);

  //await insertObjet(objet1,database);


  //print(await objet(database));

  //objet1 = Objet(1,'Kebab', 15+5);
  //await updateObjet(objet1, database);

  runApp(MyApp());
}


//////database function/////////


Future<void> insertObjet(Objet objet, Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'objet',
    objet.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}




Future<List<Objet>> objet(Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> objetMaps = await db.query('objet');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final map in objetMaps)
      Objet(map['id'] as int , map['nom'] as String, map['poids'] as int)
  ];
}


Future<void> updateObjet(Objet objet, Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'objet',
    objet.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [objet.id],
  );
}



Future<void> deleteObjet(int id, Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'objet',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

////application/////////

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, secondary: Colors.red), // Couleurs de base
          fontFamily: 'CustomFont',
          textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 20.0), // Texte principal large
          bodyMedium: TextStyle(fontSize: 25.0), // Texte principal moyen
          bodySmall: TextStyle(fontSize: 14.0), // Petit texte
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), // Grands titres
        ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //liens entre page et variable publique
  var poids=0; //variables utilisable dans myhomepage
  var nbElements =0;
  var inventaire ="";
  String annonces ="";
  var listeObjet =[new Objet(0,"apple watch",10),new Objet(1,"Big Mac",5),new Objet(2,"katana",30)];
  var objetalea=null;
  var poidsMax = 50;
  Robot robot= new Robot("Nono");
  
  var idcompte = 0;//compteur pas utilise 
  
  
  void refresh(){
  notifyListeners();
  }
  void alea(){ //alea tir nombre aléatoire
    var number = Random().nextInt(listeObjet.length - 0);
    objetalea = listeObjet[number];
  }
}

class MyHomePage extends StatelessWidget { //page text/button
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var nomRobot = appState.robot.getNom();
    String objetnom;
    TextEditingController nameController = TextEditingController();




    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Ton image de fond
            fit: BoxFit.cover, // Adapte l'image pour couvrir toute la zone
          ),
        ),
      child : ListView(
        children: [
          SizedBox(height: 50),
           Align( //nom du robot
            alignment: Alignment.centerRight,
          child : SizedBox(
          width : 300,
          child: Text("Nom robot : "+nomRobot),
          ),
          ),
          SizedBox(height: 20),
          Align( //nom du robot
            alignment: Alignment.centerRight,
            child : TextField(
              controller : nameController,
            decoration: InputDecoration(
              labelText: 'Entrez le nom du Robot',
              border: OutlineInputBorder(),
            ),
            ),
          ),
          Align( //nom du robot
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                print(name);
                appState.robot.setNom(name);
                appState.refresh();
              },
              child: Text('Envoyer le nom'),
            ),
          ),
          SizedBox(height: 20),
          Align( //liste inventaire
            alignment: Alignment.centerLeft,
          child : SizedBox(
          width : 200,
          child: Text("Inventaire : \n"+ appState.inventaire),
          ),
          ),
          SizedBox(height: 20),
          Row(children : [ //ligne
          Align( //poids
          alignment: Alignment.centerLeft,
          child : SizedBox(
          width : 150,  //si poids plus grand que max alors couleur text rouge
          child : Text("poids : "+appState.poids.toString() + " kg", style: TextStyle(color: appState.poids >= appState.poidsMax ? Colors.red : Colors.black)), 
          ),
          ),
          Align( //nb éléments
          alignment: Alignment.centerLeft,
          child : SizedBox(
          width : 200,
          child : Text("nb : "+ appState.nbElements.toString()),
          ),
          ),
          ]
          ),
          SizedBox(height: 20),
          Align( //annonces
          alignment: Alignment.centerRight,
          child : SizedBox(
          width : 500,
          child : Text("Annonces : \n"+ appState.annonces),
          ),
          ),
        //Button liste
         SizedBox(width: 10),
        Row(children :[ //ligne bouton 1
        Align( //bouton ramasser
          alignment: Alignment.centerLeft,
          child : SizedBox(
          child : ElevatedButton( //ajout d'un button
                onPressed: () {
                  print('button ramasser pressed!'); //console button pressed
                  if(appState.objetalea == null){
                    appState.annonces += "- Pas d'objet (Fouiller avant de ramasser)\n";
                  }else{
                    var ramasseroupas = appState.robot.ramasser(appState.objetalea,appState.poidsMax); 
                    if(ramasseroupas == 2){ //poids max atteint
                      appState.annonces += "- Poids Max\n";  
                      appState.objetalea=null;
                    }else{
                    appState.annonces += "- Objet Ramasser\n";
                    appState.objetalea=null;
                    }
                  }
                  appState.refresh();
                },
                child: Icon(
                  Icons.add_shopping_cart, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
                //child: Text('Ramasser'), //text du button
              ),
        ),
        ),
        SizedBox(width: 10),
        Align( //bouton deposer
          alignment: Alignment.centerLeft,
          child : SizedBox(
          child : ElevatedButton( //ajout d'un button
                onPressed: () {
                  print('button deposer pressed!'); //console button pressed
                  var deposeroupas = appState.robot.deposer();
                  if(deposeroupas == 0){
                    appState.annonces += "- inventaire vide\n";
                  }else{
                    appState.annonces += "- Objet Deposer\n";
                  }
                  appState.refresh();
                  
                },
                child: Icon(
                  Icons.archive, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
                //child: Text('Deposer'), //text du button
              ),
        ),
        ),
        ]),
        SizedBox(height: 20),
        Row(children :[ //ligne bouton 2
        Align( //bouton voir inventaire
          alignment: Alignment.centerLeft,
          child : SizedBox(
          child : ElevatedButton( //ajout d'un button
                onPressed: () {
                  appState.poids = appState.robot.poidsInventaire();
                  appState.nbElements = appState.robot.getNbElements();
                  appState.inventaire = appState.robot.voirInventaire();
                  appState.annonces="";
                  appState.refresh();
                  print('button voir inventaire pressed!'); //console button pressed
                },
                child: Icon(
                  Icons.preview, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
                ///child: Text('Voir Inventaire'), //text du button
              ),
        ),
        ),
        SizedBox(width: 10),
        Align( //bouton fouiller
          alignment: Alignment.centerLeft,
          child : SizedBox(
          child : ElevatedButton( //ajout d'un button
                onPressed: () {
                  print('button fouiller pressed!'); //console button pressed
                  appState.alea();
                  objetnom = appState.objetalea.getNom();
                  appState.annonces += "- Objet trouvé : $objetnom\n";
                  appState.refresh();
                },
                child: Icon(
                  Icons.search, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
                //child: Text('Fouiller'), //text du button
              ),
        ),
        ),
        ])
        ],
      ),
    )
    );
  }
}


class Objet{
  int id;
  String _nom;
  int _poids;


  Objet(this.id, this._nom, this._poids);

  String getNom(){
    var nom= this._nom;
    return nom;
  }

  int getPoids(){
    var poids=this._poids;
    return poids;
  }


  Map<String, Object?> toMap(){ //Object?
    return {
      'id' : this.id,
     'nom' : this.getNom(),
     'poids' : this.getPoids(), 
    };
  }

  @override
  String toString() {
    var nom = this.getNom();
    var poids = this.getPoids();
    return 'Objet{id: $id, nom: $nom, poids: $poids}';
  }

}

class Inventaire{
  List<Objet> _listeObjet=[];

  
  int ajouter(objet,poidsmax){  
      if(poidsTotal() >= poidsmax){
        return 2; //2=poids max
      }else{
      _listeObjet.add(objet);
      print(objet.getNom());
      return 1; //1=ajouter
      }
    }
  

  int supprimer(){
    var retour=0; //0=liste objet vide
    if(_listeObjet.length >= 1){
    var num = _listeObjet.length -1;  
        _listeObjet.removeAt(num);
        return retour+2; //2=supprimer
    }
    return retour;
    }

  String afficherInventaire(){ //affiche l'inventaire
    var number =1;
    String inventaireList ="";
    for(int i=0;i<_listeObjet.length;i++){
      var nom = _listeObjet[i].getNom();
      print('Objet$number : $nom');
      inventaireList +=  "Objet$number : $nom \n";
      number=number+1;
    }
    return inventaireList;
  }

  int poidsTotal(){
    int poidsTotal =0;
    for(int i=0; i<_listeObjet.length;i++){
      poidsTotal=poidsTotal + _listeObjet[i].getPoids();
    }
    return poidsTotal;
  }

  int nbElements(){
    return _listeObjet.length;
  }

}

class Robot{
  String _nom;
  Inventaire _inventaire = new Inventaire();

  Robot(this._nom);

  //methode
  int ramasser(Objet objet, int poidsmax){ //ajoute un objet
    var ajout = _inventaire.ajouter(objet, poidsmax);
    return ajout;
  }

  String voirInventaire(){ //affiche inventaire
    var voir = _inventaire.afficherInventaire();
    return voir;
  }

  int deposer(){ //supprime objet
    var supprimer = _inventaire.supprimer();
    return supprimer;
  }

  int poidsInventaire(){ //recup poids inventaire
    var poids = _inventaire.poidsTotal();
    return poids;
  }

  String getNom(){
    return _nom;
  }

  void setNom(String nom){
    _nom = nom;
  }

  int getNbElements(){ //recup nombre elements inventaire
    var nb = _inventaire.nbElements();
    return nb;
  }

}
