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
  var robotnom = "non assigné";
  var attack;
  var health;
  var defense;
  var argent;
  var inventaire="";
  
  ////pts compétences//////
  var ptscompetence = 10;
  var competencebase = 10;

  //var base//
  var attackB = 15;
  var defenceB = 6;
  var healthB = 150;
  var argentB = 125;
  var annonce="";
  var compte = 1;
  var closeFight=0;

  //battle////
  Battle battle = Battle();
  var listeShop='pas de robot';

  Map<String, Robot> _listeRobot = {
    "bot1" : new Robot('R2D2', 100, 10, 5, 0), ///vie//attack // defense
    "bot2" : new Robot('EVA01', 200, 12, 2, 0),
    "bot3" : new Robot("C3PO", 50, 5, 3, 0),
  };



  //////variable ennemi////////
  var botAlea;
  var botHealth; 
  var botDefense;
  var botAttack;




  void refresh(){
  notifyListeners();
  }

  void alea(){
    int random = Random().nextInt(_listeRobot.length);
    botAlea = _listeRobot.values.elementAt(random);
    botHealth = botAlea.getHealth();
    botDefense = botAlea.getDefense();
    botAttack = botAlea.getAttack();
  }

}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var testcompetence = appState.ptsCompetence; 
    TextEditingController nameController = TextEditingController();
    var nombot = appState.robotnom;


    if(appState.robot is Robot){
        appState.defense = appState.robot.getDefense();
        appState.attack = appState.robot.getAttack();
        appState.health = appState.robot.getHealth();
        appState.argent = appState.robot.getArgent();
      }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Ton image de fond
            fit: BoxFit.cover, // Adapte l'image pour couvrir toute la zone
          ),
        ),
        child : Column(
        children: [
          SizedBox(height : 50),
          Align( //message bienvenue
          alignment: Alignment.center,
          child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
          ),
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child : Text('Bienvenue sur BattleDroids',style: TextStyle(color: Color(0xFF89CC04),fontSize: 20.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          SizedBox(height : 20),
          Align( //message explication
          alignment: Alignment.center,
          child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
          ),
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child : Text('Créez votre robot, achetez-lui des équipements et que la bataille commence !!!',style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          SizedBox(height : 20),
          Align( //nom robot
          alignment: Alignment.center,
          child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
          ),
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child : Text("Votre robot s'apelle : $nombot",style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          SizedBox(height : 20),
          Align( //entrer nom robot
            alignment: Alignment.center,
            child : TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Entrez le nom du Robot',
              labelStyle: TextStyle(
              color: Color(0xFF89CC04), // Couleur du texte du label
              fontSize: 18.0, // Taille du texte du label (facultatif)
              fontWeight: FontWeight.bold, // Gras pour le texte du label (facultatif)
              ),
              border: OutlineInputBorder(),
              filled: true, // Active le remplissage
              fillColor: Colors.black, // Définit le fond blanc
            ),
            style: TextStyle(
            color: Color(0xFF89CC04), // Définit la couleur du texte
            fontSize: 16.0, // Optionnel : ajuste la taille du texte
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
                appState.alea();
                appState.closeFight=0;
                appState.compte=1;
                appState.refresh();
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
              foregroundColor: Colors.black, // Couleur du texte
              ),
              child: Icon(
                  Icons.send, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
            ),
          ),
          SizedBox(height : 20),  
        ElevatedButton( //ajout d'un button
          onPressed: () {
            if(appState.robot is Robot){
              appState.annonce="";
            Navigator.pushNamed(context, '/shopskill');
            }else{
              appState.annonce = 'robot non présent';
              appState.refresh();
            }
          },
          style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
          foregroundColor: Colors.black, // Couleur du texte
          ),
          child: Text('ShopSkill',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
        ),
        ElevatedButton( //Button Accueil
          onPressed: () {
          if(appState.robot is Robot){
          appState.annonce="";
          Navigator.pushNamed(context, '/assault');
          }else{
            appState.annonce = 'robot non présent';
            appState.refresh();
            }
          },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
            child: Text('Combattre',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          Align(
            alignment: Alignment.center,
            child: DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Text(appState.annonce,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),
      ]),
      ),
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
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Ton image de fond
            fit: BoxFit.cover, // Adapte l'image pour couvrir toute la zone
          ),
        ),
        child : ListView(children : [
        Column(
          children: [
            SizedBox(height : 50),
            Align(
            alignment: Alignment.center,
            child: DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text('Shop et Skill',style: TextStyle(color: Color(0xFF89CC04),fontSize: 20.0,fontWeight: FontWeight.bold,),),
            ),
            ),
            ),
            SizedBox(height : 20),
            Align( //zone text 
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text('  Argent : $argent€ // points de compétences : $testcompetence',style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),
            ),
            SizedBox(height : 20),
            
            /////Attack///////
            Align(
            alignment: Alignment.center,
            child: Container(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [ 
            DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text('Attack : $attack',style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),
            SizedBox(width : 20),
            ElevatedButton( //ajout d'un button
               onPressed: () {
              if(appState.ptsCompetence > 0){
               appState.robot.upAttack(1);
               appState.refresh();
               appState.ptsCompetence -= 1;
              }
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
            child: Text('+',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ElevatedButton( //ajout d'un button
               onPressed: () {
                if(appState.ptsCompetence< appState.competencebase){
               appState.robot.downAttack(1);
               appState.refresh();
               appState.ptsCompetence +=1;
              }
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
             child: Text('-',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
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
            DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child: Padding(
            padding: const EdgeInsets.all(8.0),   
            child : Text('Défense : $defense',style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),
            SizedBox(width : 20),
            ElevatedButton( //ajout d'un button
               onPressed: () {
              if(appState.ptsCompetence > 0){
               appState.robot.upDefense(1);
               appState.refresh();
               appState.ptsCompetence -= 1;
              }
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
             child: Text('+',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ElevatedButton( //ajout d'un button
               onPressed: () {
                if(appState.ptsCompetence< appState.competencebase){
               appState.robot.downDefense(1);
               appState.refresh();
               appState.ptsCompetence +=1;
              }
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
             child: Text('-',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
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
            children :[ 
            DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text('Health : $health',style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),
            SizedBox(width : 20),
            ElevatedButton( //ajout d'un button
               onPressed: () {
              if(appState.ptsCompetence > 0){
               appState.robot.upHealth(1);
               appState.refresh();
               appState.ptsCompetence -= 1;
              }
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
             child: Text('+',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ElevatedButton( //ajout d'un button
               onPressed: () {
                if(appState.ptsCompetence< appState.competencebase){
               appState.robot.downHealth(1);
               appState.refresh();
               appState.ptsCompetence +=1;
              }
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
             child: Text('-',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
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
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
            child: Icon(
                  Icons.restore, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
          ),



          //////////Shop////////////////
          SizedBox(height : 20),
          Divider(
          color: Colors.black,
          thickness: 2,
          ),
          Align(
            alignment: Alignment.center,
            child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text('Boutique',style: TextStyle(color: Color(0xFF89CC04),fontSize: 20.0,fontWeight: FontWeight.bold,),),
            ),
            ),
          ),
          SizedBox(height : 20),
          Align(
            alignment: Alignment.center,
            child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text(listeShop,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),
          ),
          SizedBox(height : 20),
          Align( //entrer numéro objet
            alignment: Alignment.center,
            child : TextField(
              controller : nameController,
            decoration: InputDecoration(
              labelText: 'Entrez numéro objet',
              labelStyle: TextStyle(
              color: Color(0xFF89CC04), // Couleur du texte du label
              fontSize: 18.0, // Taille du texte du label (facultatif)
              fontWeight: FontWeight.bold, // Gras pour le texte du label (facultatif)
              ),
              border: OutlineInputBorder(),
              filled: true, // Active le remplissage
              fillColor: Colors.black, // Définit le fond blanc
            ),
            style: TextStyle(
            color: Color(0xFF89CC04), // Définit la couleur du texte
            fontSize: 16.0, // Optionnel : ajuste la taille du texte
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
                  appState.inventaire = appState.robot.afficherInventaire();
                }
                appState.listeShop = appState.battle.afficherListeObjet();
                appState.refresh();
              },
              style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
              child: Icon(
                  Icons.add_shopping_cart, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Text(appState.annonce,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),

          SizedBox(height : 20),

          ElevatedButton( //Button Accueil
            onPressed: () {
              appState.annonce="";
              Navigator.pushNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
            child: Text('Retour Accueil',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ElevatedButton( //Button Accueil
            onPressed: () {
              appState.annonce="";
              Navigator.pushNamed(context, '/assault');
            },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
            child: Text('Combattre',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
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

      var inventaire = appState.inventaire;


      var healthBot = appState.botAlea.getHealth();
      var attackBot = appState.botAlea.getAttack();
      var defenseBot = appState.botAlea.getDefense();
      var nomBot = appState.botAlea.getNom();

      TextEditingController nameController = TextEditingController();

      return Scaffold(
        body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Ton image de fond
            fit: BoxFit.cover, // Adapte l'image pour couvrir toute la zone
          ),
        ),
        child : ListView(children : [
        Column(
          children: [
            SizedBox(height : 50),
            Align(
            alignment: Alignment.center,
            child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Padding(
            padding: const EdgeInsets.all(8.0),
            child : Text('Battle',style: TextStyle(color: Color(0xFF89CC04),fontSize: 20.0,fontWeight: FontWeight.bold,),),
            ),
            ),
            ),
          Align(
          alignment: Alignment.centerLeft,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Padding(
            padding: const EdgeInsets.all(8.0),
          child : Text('Inventaire : \n$inventaire',style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          
          
          ////texte robot
          Align( 
          alignment: Alignment.centerRight,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text('Robot : ' + appState.robotnom, textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          Align( 
          alignment: Alignment.centerRight,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text("Point de vie : " + appState.health.toString(), textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          Align( 
          alignment: Alignment.centerRight,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text("Point d'attack : " + appState.attack.toString(), textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          Align( 
          alignment: Alignment.centerRight,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text("Point de Défence : " + appState.defense.toString(), textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          SizedBox(width : 50),

          //text Robot ennemi
          Align( 
          alignment: Alignment.centerLeft,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text('Robot : ' + nomBot, textAlign: TextAlign.right,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          Align( 
          alignment: Alignment.centerLeft,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text("Point de vie : " + healthBot.toString(), textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          Align( 
          alignment: Alignment.centerLeft,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text("Point d'attack : " + attackBot.toString(), textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          Align( 
          alignment: Alignment.centerLeft,
          child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
          child: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child : Text("Point de Défence : " + defenseBot.toString(), textAlign: TextAlign.left,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),
          ),
          ),
          SizedBox(height : 20),

          ////////Utiliser Objet // Fight ////////
          Align( //entrer numéro objet
            alignment: Alignment.center,
            child : TextField(
              controller : nameController,
              decoration: InputDecoration(
              labelText: 'Entrez numéro objet',
              labelStyle: TextStyle(
              color: Color(0xFF89CC04), // Couleur du texte du label
              fontSize: 18.0, // Taille du texte du label (facultatif)
              fontWeight: FontWeight.bold, // Gras pour le texte du label (facultatif)
              ),
              border: OutlineInputBorder(),
              filled: true, // Active le remplissage
              fillColor: Colors.black, // Définit le fond blanc
            ),
            style: TextStyle(
            color: Color(0xFF89CC04), // Définit la couleur du texte
            fontSize: 16.0, // Optionnel : ajuste la taille du texte
            ),
            ), 
            ),

            Align( //envoyer numéro objet button
            alignment: Alignment.centerRight,
            child : Row( children : [
            ElevatedButton(
              onPressed: () {
                String num = nameController.text;
                int number = int.parse(num);
                number = number-1;
                
                int res = appState.battle.utiliserObjet(appState.robot, number);
                if(res == 0){
                  appState.annonce+="Objet non trouvé\n";
                }else{
                  appState.annonce="Objet utilisé\n";
                  appState.inventaire = appState.robot.afficherInventaire();
                  appState.defense = appState.robot.getDefense();
                  appState.attack = appState.robot.getAttack();
                  appState.health = appState.robot.getHealth();
                }
                appState.refresh();
              },
              style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
              child: Text('Utiliser Objet',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ElevatedButton( //button combat
               onPressed: () {
                if(appState.closeFight == 0){
                appState.annonce="";
                var compte = appState.compte;
                appState.annonce += "---- Manche $compte -----\n";
                var vierob1 = appState.robot.getHealth();
                var vierob2 = appState.botAlea.getHealth();
                var test = appState.battle.attackRobot(appState.robot, appState.botAlea);

                var calcvie = vierob2 - appState.botAlea.getHealth();

                appState.annonce += "vous avez infligé $calcvie point de dégats au robot adverse\n";

                test = appState.battle.attackRobot(appState.botAlea, appState.robot);

                calcvie = vierob1 - appState.robot.getHealth(); 
                appState.compte +=1;
                appState.annonce += "l'adversaire vous a infligé $calcvie point de dégats\n";
                if(appState.robot.getHealth() <= 0){
                  appState.annonce = "Vous avez perdu !!!";
                  appState.closeFight = 1;
                  appState.robot.setHealth(0);
                }if(appState.botAlea.getHealth() <= 0){
                  appState.annonce = "Vous avez gagné !!!";
                  appState.botAlea.setHealth(0);
                  appState.closeFight = 1;
                }
                }else if(appState.closeFight==1){
                  appState.annonce= "combat terminé veuillez recréé un robot";
                }
                appState.refresh();
             },
             style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
             child: Icon(
                  Icons.sports_mma, // Choisissez l'icône souhaitée
                  size: 24.0, // Taille de l'icône
                  color: Colors.black, // Couleur de l'icône
                ),
            ),



            ElevatedButton( //Button Accueil
            onPressed: () {
              if(appState.closeFight == 1){
              appState.annonce="";
              appState.robot = null;
              appState.robotnom = "non assigné";
              appState.botAlea.setHealth(appState.botHealth);
              appState.botAlea.setDefence(appState.botDefense);
              appState.botAlea.setAttack(appState.botAttack);

              Navigator.pushNamed(context, '/');
              }else if(appState.closeFight == 0){
                appState.annonce += "Vous n'avez pas terminé le combat\n";
              }
              appState.refresh();
            },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89CC04), // Couleur de fond du bouton
            foregroundColor: Colors.black, // Couleur du texte
            ),
            child: Text('Retour Accueil',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),),
          ),



          ]),
          ),
           Align(
            alignment: Alignment.center,
            child : DecoratedBox(
            decoration: BoxDecoration(
            color: Colors.black, // Fond blanc
            ),
            child : Text(appState.annonce,style: TextStyle(color: Color(0xFF89CC04),fontSize: 16.0,fontWeight: FontWeight.bold,),),
            ),
            ),


         
          /////////////////////////////////
          






          /////////////////////////


        ]),
        ]),
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
      int pointtest = inventaire[i].getPoint();
      liste += "${i+1} -> $nomtest : $pointtest Points d'action\n";
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
    "Armure en Fer": Objet("Armure en Fer", 75, 2, 3),
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
    if(obj < robot.inventaire.length){
    Objet objetUse = robot.inventaire[obj];
    int pointAction = objetUse.getPoint();
    if(objetUse.getType() == 1){ //soin
      robot.upHealth(pointAction);
      test = test+1;
    }else if(objetUse.getType() == 2){ //defense
      robot.upDefense(pointAction);
      test = test+1;
    }else if(objetUse.getType() == 3){ //attack
      robot.upAttack(pointAction);
      test = test+1;
    }
    
    if(test == 1){ //supprime l'objet une fois utiliser
      robot.deleteObjFromInventaire(obj);
    }
    return test; //objet supprimer/utiliser avec succès
    }else{
      return test;
    }
  }

  int attackRobot(Robot robot1, Robot robot2){ //robot 1 attack le 2
    int ptsAttack = robot1.getAttack(); //attack robot
    int ptsHealth = robot2.getHealth(); //pts vie robot2

    int calc = ptsAttack - robot2.getDefense(); //calcul attack moins défense robot2
    robot2.downHealth(calc.abs()); //attack le robot2
    return 1; //robot attacker avec succès
  }



}
