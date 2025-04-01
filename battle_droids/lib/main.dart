import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'BattleDroids',
        routes: {
        '/': (context) => MyHomePage(),
        '/shopskill': (context) => ShopSkillPage(),
        // '/third': (context) => ThirdPage(),
        },
        initialRoute:'/',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var ptsCompetence =10;
  var robot;
  
  //variable robot
  var robotnom;
  var attack;
  var health;
  var defense;
  var argent;



  void refresh(){
  notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var testcompetence = appState.ptsCompetence; 
    TextEditingController nameController = TextEditingController();
    var nombot = appState.robotnom;


    return Scaffold(
      body: Column(
        children: [
          SizedBox(height : 50),
          Align( //message bienvenue
          alignment: Alignment.center,
          child : Text('Bienvenue sur BattleDroids'),

          ),
          SizedBox(height : 20),
          Align( //message explication
          alignment: Alignment.center,
          child : Text('Créez votre robot, achetez-lui des équipements et que la bataille commence !!!'),
          ),
          SizedBox(height : 20),
          Align( //nom robot
          alignment: Alignment.center,
          child : Text("Votre robot s'apelle : $nombot"),
          ),
          SizedBox(height : 20),
          Align( //entrer nom robot
            alignment: Alignment.center,
            child : TextField(
              controller : nameController,
            decoration: InputDecoration(
              labelText: 'Entrez le nom du Robot',
              border: OutlineInputBorder(),
            ),
            ), 
            ),
          Align( //envoyer nom robot button
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                print(name);
                appState.robot = new Robot(name, 150, 15, 12, 125);
                appState.robotnom = name;
                appState.refresh();
              },
              child: Text('Envoyer le nom'),
            ),
          ),
          SizedBox(height : 20),  
        ElevatedButton( //ajout d'un button
          onPressed: () {
            // appState.ptsCompetence += 1;
            // print(''); //console button pressed
            // appState.refresh();
            Navigator.pushNamed(context, '/shopskill');
          },
          child: Text('ShopSkill'),
        ),
      ]),
      
    );
  }
}


  class ShopSkillPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      var appState = context.watch<MyAppState>();
      var testcompetence = appState.ptsCompetence;

      if(appState.robot is Robot){
        appState.defense = appState.robot.getDefense();
        appState.attack = appState.robot.getAttack();
        appState.health = appState.robot.getHealth();
        appState.argent = appState.robot.getArgent();
      }


      var defense = appState.defense;
      var attack = appState.attack;
      var health = appState.health;
      var argent = appState.argent;


      return Scaffold(
        body: Column(
          children: [
            SizedBox(height : 50),
            Align(
            alignment: Alignment.center,
            child : Text('Shop et Skill'),
            ),
            Align( //zone text 
            alignment: Alignment.centerLeft,
            child : Text('  Argent : $argent€'),
            child : ElevatedButton( //ajout d'un button
              onPressed: () {
              Navigator.pushNamed(context, '/shopskill');
            },
            child: Text('+'),
            ),
            ),
            SizedBox(height : 20),
            Align(
            alignment: Alignment.center,
            child : Text('Attack : $attack'),
            ),
            SizedBox(height : 20),
            Align(
            alignment: Alignment.center,
            child : Text('Défense : $defense'),
            ),
            SizedBox(height : 20),
            Align(
            alignment: Alignment.center,
            child : Text('Health : $health'),
            ),
            SizedBox(height : 20),
          ElevatedButton( //ajout d'un button
            onPressed: () {
              // appState.ptsCompetence += 1;
              // print(''); //console button pressed
              // appState.refresh();
              Navigator.pushNamed(context, '/');
            },
            child: Text('Retour Accueil'),
          ),
        ]),
        
      );
    }
  }

class Robot {
  String _nom;
  int _health;
  int _attack;
  int _defense;
  int _argent;
  List<Objet> inventaire=[];


  Robot(this._nom, this._health, this._attack, this._defense, this._argent);


  String getNom() {
    return this._nom;
  }

  int getHealth() {
    return this._health;
  }

  int getAttack() {
    return this._attack;
  }

  int getDefense() {
    return this._defense;
  }

  void setNom(String nom) {
    this._nom = nom;
  }

  void upHealth(int health) {
    this._health += health;
  } 

  void downHealth(int health) {
    this._health -= health;
  } 

  void setAttack(int attack) {
    this._attack += attack;
  } 

  void setDefense(int defense) {
    this._defense += defense;
  } 

  void upArgent(int argent) {
    this._argent += argent;
  }

  void downArgent(int argent) {
    this._argent -= argent;
  }

  int getArgent() {
    return this._argent;
  }


  int deleteObjFromInventaire(int obj){
    inventaire.removeAt(obj);
    return 1; //obj supprimer
  }

  String afficherInventaire(){
    String liste = "";
    for(int i=0; i<inventaire.length; i++){ //listeObjet[0]
      String nomtest = inventaire[i].getNom();
      int prixtest = inventaire[i].getPrix();
      liste += "$nomtest : $prixtest\n";
    }
    return liste;
  }


}


class Objet{
  Map<String, Objet> _listeObjet = {
    "Potion de soin": Objet("Potion de soin", 10, 1, 10),
    "Armure en Fer": Objet("Armure en Fer", 10, 2, 10),
    "Parchemin magique": Objet("Parchemin magique", 10, 3, 10), //...
  };
  int prix;
  String nom;
  int type; //soin,defense,attack 1/2/3
  int point;

  Objet(this.nom, this.prix, this.type, this.point);

  String getNom(){
    return this.nom;
  }

  int getPrix(){
    return this.prix;
  }

  int getType(){
    return this.type;
  }

  int getPoint(){
    return this.point;
  }

  String afficherListeObjet(){
    String liste = "";
    for(int i=0; i<_listeObjet.length; i++){ //listeObjet[0]
      String nomtest = _listeObjet.keys.elementAt(i);
      int prixtest = _listeObjet.values.elementAt(i).getPrix();
      liste += "$nomtest : $prixtest\n";
    }
    return liste;
  }
}


class Battle{

  int acheterObjet(Map<String, Objet> listeShop, int obj, Robot robot){ //obj numéro objet
    int retour =1; //pas assez d'argent
      if(listeShop.values.elementAt(obj).getPrix() < robot.getArgent()){
        robot.inventaire.add(listeShop.values.elementAt(obj));
        retour = 2; //objet acheter
        String nomObj = listeShop.values.elementAt(obj).getNom();
        robot.downArgent(listeShop.values.elementAt(obj).getPrix());//retire argent robot
        listeShop.remove(nomObj);
      }
    return retour;  
  }


  int afficherShop(){
    Objet test = new Objet("test", 1, 1, 1);
    test.afficherListeObjet();
    return 1;
  }


  int utiliserObjet(Robot robot, int obj){//obj numéro objet
    int test=0;
    Objet objetUse = robot.inventaire[obj];
    int pointAction = objetUse.getPoint();
    if(objetUse.getType() == 1){ //soin
      robot.upHealth(pointAction);
      test = test+1;
    }else if(objetUse.getType() == 2){ //defense
      robot.setDefense(pointAction);
      test = test+1;
    }else if(objetUse.getType() == 3){ //attack
      robot.setAttack(pointAction);
      test = test+1;
    }

    if(test == 1){ //supprime l'objet une fois utiliser
      robot.deleteObjFromInventaire(obj);
    }
    return test; //objet supprimer/utiliser avec succès
  }

  int attackRobot(Robot robot1, Robot robot2){ //robot 1 attack le 2
    int ptsAttack = robot1.getAttack(); //attack robot
    int ptsHealth = robot2.getHealth(); //pts vie robot2
    int calc = ptsAttack - robot2.getDefense(); //calcul attack moins défense robot2
    robot2.downHealth(calc); //attack le robot2
    return 1; //robot attacker avec succès
  }



}
