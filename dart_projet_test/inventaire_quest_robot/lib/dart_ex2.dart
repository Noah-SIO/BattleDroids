import 'dart:io';  

class Objet{
  String _nom;
  int _poids;

  Objet(this._nom, this._poids);

  String getNom(){
    var nom= this._nom;
    return nom;
  }

  int getPoids(){
    var poids=this._poids;
    return poids;
  }

}

class Inventaire{
  List<Objet> _listeObjet=[];

  

  //methode
  int ajouter(objet){ //0=null, 1=ajouter
      _listeObjet.add(objet);
      return 1;
    }
  

  int supprimer(num){ //0=existe pas, 1=null, 2=supprimer
    var retour=0;
    if(num == null || num.isEmpty){
    return retour+1;
    }else{
        int number = int.parse(num);
        number=number-1;
        if(_listeObjet.length >= number){  
          _listeObjet.removeAt(number);
          return retour+2;
        }else{
          return retour;
        }
        } 
    }

  void afficherInventaire(){ //affiche l'inventaire
    var number =1;
    for(int i=0;i<_listeObjet.length;i++){
      var nom = _listeObjet[i].getNom();
      print('Objet$number : $nom');
      number=number+1;
    }
  }

  int poidsTotal(){
    int poidsTotal =0;
    for(int i=0; i<_listeObjet.length;i++){
      poidsTotal=poidsTotal + _listeObjet[i].getPoids();
    }
    return poidsTotal;
  }

}

class Robot{
  String _nom;
  Inventaire _inventaire = new Inventaire();

  Robot(this._nom);

  //methode
  int ramasser(Objet objet){ //ajoute un objet
    var ajout = _inventaire.ajouter(objet);
    return ajout;
  }

  void voirInventaire(){ //affiche inventaire
    _inventaire.afficherInventaire();
  }

  int deposer(num){
    var supprimer = _inventaire.supprimer(num);
    return supprimer;
  }

  int poidsInventaire(){
    var poids = _inventaire.poidsTotal();
    return poids;
  }

}


void main(){
  //inventaire obj
  var robot=null;
  print("Entrer le nom de votre Robot : "); //demande objet à supprimer
  String nom = stdin.readLineSync()!;
  
  while(nom != null){
  if(nom == null || nom.isEmpty){
    print('|||||Nom null|||||');
  }else{
  robot = new Robot(nom);
  break;
  }
  }

  //menu
  var choix='0';
  while(choix != '4'){
  print('---------------');  
  print('1. Ramasser');
  print('2. Deposer');
  print('3. Afficher Inventaire');
  print('4. Poids Inventaire');
  print('5. Exit');
  print("-> Entrer un choix (5. pour fermer) : ");
  print('---------------'); 
  String choix = stdin.readLineSync()!;
  

  //test choix de l'utilisateur
  if(choix == '1'){
    var objet = new Objet('Pomme de Terre', 10);
    robot.ramasser(objet);
    print('|||||Objet ramasser avec succès|||||');
    robot.voirInventaire();
  }if(choix == '2'){
    robot.voirInventaire();
    print("-> numéro objet que vous voulez deposer : "); 
    String suppr = stdin.readLineSync()!;
    var test = robot.deposer(suppr);
    
    if(test == 1){
      print('|||||Objet Null|||||');
    }if(test == 2){
      print('|||||Objet deposer avec succès|||||');
    }else{
      print('|||||Objet pas présent dans Inventaire|||||');
    }

    robot.voirInventaire();
  }if(choix == '3'){
    print('|||||Votre inventaire|||||');
    robot.voirInventaire();
    print('|||||||||||||||||||||||||||');
  }if(choix =='4'){
    var poids = robot.poidsInventaire();
    print("|||||L'inventaire à un poids de $poids kg|||||");
  }
  if(choix =='5'){
    print('///Fin du programme///');
    break;
  }

  }

}

