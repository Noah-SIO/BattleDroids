import 'package:dart_test/dart_test.dart' as dart_test;
import 'dart:io';  
void main() {
  //variable liste
  List<String> listeObjet = ['Epee rouillee','Potion de soin','Arc en bois','Bouclier en fer'];
  //demande un nouveau objet

  var choix='test';
  
  while(choix != 'exit'){
  print('///vous pouvez supprimer,afficher,rechercher ou ajouter des objets///');
  print("-> Entrer un choix (exit pour fermer) : "); 
  String choix = stdin.readLineSync()!;
  

  //test choix de l'utilisateur
  if(choix == 'supprimer'){
    supprimerObjet(listeObjet);
  }if(choix=='ajouter'){
    ajouterObjet(listeObjet);
  }if(choix=='afficher'){
    afficherInventaire(listeObjet);
  }if(choix =='exit'){
    print('///Fin du programme///');
    break;
  }if(choix == 'rechercher'){
    rechercheObjet(listeObjet);
  }
  }
}


//fonction affiche objet
void afficherInventaire(inventaire){
  print(inventaire);//affiche l'inventaire

  var longeurliste = inventaire.length;
  print("nombre d'élément restant : $longeurliste");

  if(longeurliste >= 5){ //si longueur plus de 5
    print('inventaire pleins');
    print(inventaire);
  }if(inventaire.isEmpty){ // si rien dedans
    print('inventaire vide');
  }
}

void ajouterObjet(listeObjet){
  //demande un objet
  print("Entrer un nouvel objet : ");  
  String? obj = stdin.readLineSync(); //demande new objet
  //ajoute dans la liste

  var longeurliste = listeObjet.length;
  if(longeurliste >= 5){ //si longueur plus de 5
    print('|||||Inventaire pleins|||||');
  }else{ //si inventaire pas pleins
  if(obj == null || obj.isEmpty){
    print('|||||Objet null|||||');
  }else{
    listeObjet.add(obj);
    print('|||||Elements ajouter avec succès|||||');
  }
  }
  //tri alphabetique
  listeObjet.sort();
}

void supprimerObjet(listeObjet){
  print("Entrer l'objet que vous voulez supprimer : "); //demande objet à supprimer
  String suppr = stdin.readLineSync()!;
  
  if(suppr == null || suppr.isEmpty){
    print('|||||Objet null|||||');
  }else{

  listeObjet.remove(suppr); //le supprime de la liste
  //affiche nb objet restant
  print('|||||Elements supprimer avec succès|||||');
  }

  var longeurliste = listeObjet.length;
  print("nombre d'élément restant : $longeurliste");
}



void rechercheObjet(listeObjet){
  print("Entrer l'objet que vous voulez rechercher : "); //demande objet à chercher
  String search = stdin.readLineSync()!;
  var test =0;
  if(search == null || search.isEmpty){ //test si recherche null
    print('|||||Objet null|||||');
  }else{ //sinon continuer d'executer
    for(int i=0;i<listeObjet.length;i++){ //boucle sur la liste d'objet 
      if(listeObjet[i] == search){ //test si l'objet est présent dans la liste
        test=1;
        print('|||||Objet présent dans la liste|||||');
      }
    }
    if(test==0){ //sinon objet non présent
      print('|||||Objet non présent|||||');
    }
  }
}



//test return bool
bool testbool(){
  return true; 
}

