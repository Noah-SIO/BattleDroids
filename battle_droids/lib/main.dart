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
        '/assault': (context) => AssaultPage(),
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
  
  ////pts compétences//////
  var ptscompetence = 10;
  var competencebase = 10;

  //var base//
  var attackB = 15;
  var defenceB = 12;
  var healthB = 150;
  var argentB = 125;
  var annonce="";

  //battle////
  Battle battle = Battle();
  var listeShop='pas de robot';


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
                appState.robot = new Robot(name, appState.healthB, appState.attackB, appState.defenceB, appState.argentB);
                appState.robotnom = name;
                appState.listeShop = appState.battle.afficherListeObjet();
                appState.annonce="";
                appState.refresh();
              },
              child: Text('Envoyer le nom'),
            ),
          ),
          SizedBox(height : 20),  
        ElevatedButton( //ajout d'un button
          onPressed: () {
            if(appState.robot is Robot){
            Navigator.pushNamed(context, '/shopskill');
            }else{
              appState.annonce = 'robot non présent';
              appState.refresh();
            }
          },
          child: Text('ShopSkill'),
        ),
        ElevatedButton( //Button Accueil
          onPressed: () {
          if(appState.robot is Robot){
          Navigator.pushNamed(context, '/assault');
          }else{
            appState.annonce = 'robot non présent';
            appState.refresh();
            }
          },
            child: Text('Combattre'),
          ),
          Align(
            alignment: Alignment.center,
            child : Text(appState.annonce),
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
      TextEditingController nameController = TextEditingController();

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


      var listeShop = appState.listeShop;
      

      return Scaffold(
        body: Container(
        child : ListView(children : [
        Column(
          children: [
            SizedBox(height : 50),
            Align(
            alignment: Alignment.center,
            child : Text('Shop et Skill'),
            ),
            SizedBox(height : 20),
            Align( //zone text 
            alignment: Alignment.centerLeft,
            child : Text('  Argent : $argent€ // points de compétences : $testcompetence'),
            ),
            SizedBox(height : 20),
            
            /////Attack///////
            Align(
            alignment: Alignment.center,
            child: Container(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [ Text('Attack : $attack'),
            SizedBox(width : 20),
            ElevatedButton( //ajout d'un button
               onPressed: () {
              if(appState.ptsCompetence > 0){
               appState.robot.upAttack(1);
               appState.refresh();
               appState.ptsCompetence -= 1;
              }
             },
             child: Text('+'),
            ),
            ElevatedButton( //ajout d'un button
               onPressed: () {
                if(appState.ptsCompetence< appState.competencebase){
               appState.robot.downAttack(1);
               appState.refresh();
               appState.ptsCompetence +=1;
              }
             },
             child: Text('-'),
            ),
          ]),
            ),
            ),
          ///////////////////////  
            
            
            SizedBox(height : 20),



            /////Defence//////
            Align(
            alignment: Alignment.center,
            child: Container(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [  
            Text('Défense : $defense'),
            SizedBox(width : 20),
            ElevatedButton( //ajout d'un button
               onPressed: () {
              if(appState.ptsCompetence > 0){
               appState.robot.upDefense(1);
               appState.refresh();
               appState.ptsCompetence -= 1;
              }
             },
             child: Text('+'),
            ),
            ElevatedButton( //ajout d'un button
               onPressed: () {
                if(appState.ptsCompetence< appState.competencebase){
               appState.robot.downDefense(1);
               appState.refresh();
               appState.ptsCompetence +=1;
              }
             },
             child: Text('-'),
            ),
          ]),
            ),
            ),

            //////////////////




            SizedBox(height : 20),



            ///////Health/////////
            Align(
            alignment: Alignment.center,
            child: Container(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children :[ Text('Health : $health'),
            SizedBox(width : 20),
            ElevatedButton( //ajout d'un button
               onPressed: () {
              if(appState.ptsCompetence > 0){
               appState.robot.upHealth(1);
               appState.refresh();
               appState.ptsCompetence -= 1;
              }
             },
             child: Text('+'),
            ),
            ElevatedButton( //ajout d'un button
               onPressed: () {
                if(appState.ptsCompetence< appState.competencebase){
               appState.robot.downHealth(1);
               appState.refresh();
               appState.ptsCompetence +=1;
              }
             },
             child: Text('-'),
            ),
            ]),
            ),
            ),
            //////////////////////////
            

            SizedBox(height : 20),

          ElevatedButton( //Button Reset
            onPressed: () {
              appState.robot.setAttack(appState.attackB);
              appState.robot.setDefence(appState.defenceB);
              appState.robot.setHealth(appState.healthB);
              appState.ptsCompetence = appState.competencebase;
              appState.refresh();
            },
            child: Text('Reset Points'),
          ),



          //////////Shop////////////////
          SizedBox(height : 20),
          Divider(
          color: Colors.black,
          thickness: 2,
          ),
          Align(
            alignment: Alignment.center,
            child : Text('Boutique'),
          ),
          SizedBox(height : 20),
          Align(
            alignment: Alignment.center,
            child : Text(listeShop),
          ),
          SizedBox(height : 20),
          Align( //entrer numéro objet
            alignment: Alignment.center,
            child : TextField(
              controller : nameController,
            decoration: InputDecoration(
              labelText: 'numéro objet',
              border: OutlineInputBorder(),
            ),
            ), 
            ),



            Align( //envoyer numéro objet button
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                String num = nameController.text;
                int number = int.parse(num);
                number = number-1;
                
                int res = appState.battle.acheterObjet(number, appState.robot);
                if(res == 1){
                  appState.annonce="Pas assez d'argent";
                }else{
                  appState.annonce="Objet acheter avec succès";
                }
                appState.listeShop = appState.battle.afficherListeObjet();
                appState.refresh();
              },
              child: Text('Acheter'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child : Text(appState.annonce),
            ),

          SizedBox(height : 20),

          ElevatedButton( //Button Accueil
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text('Retour Accueil'),
          ),
          ElevatedButton( //Button Accueil
            onPressed: () {
              Navigator.pushNamed(context, '/assault');
            },
            child: Text('Combattre'),
          ),
        ]),
        ])
        )
      );
    }
  }




  class AssaultPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      var appState = context.watch<MyAppState>();

      return Scaffold(
        body: Container(
        child : Align(
            alignment: Alignment.center,
            child : Text('Page 3 coucou'),
            ),
        ),
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

  void setHealth(int health) {
    this._health = health;
  } 

  void setDefence(int def) {
    this._defense = def;
  }

  void setAttack(int attack) {
    this._attack = attack;
  } 

  void upHealth(int health) {
    this._health += health;
  } 

  void downHealth(int health) {
    this._health -= health;
  } 

  void upAttack(int attack) {
    this._attack += attack;
  } 

  void downAttack(int attack) {
    this._attack -= attack;
  } 

  void upDefense(int defense) {
    this._defense += defense;
  } 

  void downDefense(int defense) {
    this._defense -= defense;
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
}


class Battle{

  Map<String, Objet> _listeObjet = {
    "Potion de soin": Objet("Potion de soin", 10, 1, 10),
    "Armure en Fer": Objet("Armure en Fer", 75, 2, 15),
    "Parchemin magique": Objet("Parchemin magique", 25, 3, 10), //...
  };

  int acheterObjet(int obj, Robot robot){ //obj numéro objet
    int retour =1; //pas assez d'argent
      if(this._listeObjet.values.elementAt(obj).getPrix() < robot.getArgent()){
        robot.inventaire.add(this._listeObjet.values.elementAt(obj));
        retour = 2; //objet acheter
        String nomObj = this._listeObjet.values.elementAt(obj).getNom();
        robot.downArgent(this._listeObjet.values.elementAt(obj).getPrix());//retire argent robot
        this._listeObjet.remove(nomObj);
      }
    return retour;  
  }


    String afficherListeObjet(){
    String liste = "";
    for(int i=0; i<_listeObjet.length; i++){ //listeObjet[0]
      String nomtest = _listeObjet.keys.elementAt(i);
      int prixtest = _listeObjet.values.elementAt(i).getPrix();
      liste += "${i+1} -> $nomtest : $prixtest€\n";
    }
    return liste;
  }


  int utiliserObjet(Robot robot, int obj){//obj numéro objet
    int test=0;
    Objet objetUse = robot.inventaire[obj];
    int pointAction = objetUse.getPoint();
    if(objetUse.getType() == 1){ //soin
      robot.upHealth(pointAction);
      test = test+1;
    }else if(objetUse.getType() == 2){ //defense
      robot.upArgent(pointAction);
      test = test+1;
    }else if(objetUse.getType() == 3){ //attack
      robot.upAttack(pointAction);
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
