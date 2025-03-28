//import 'package:dart_test/dart_test.dart';
//import 'package:test/test.dart';
import 'dart:io'; 

void main() {

  List<String> listeObjet = ['Épée rouillée','Potion de soin','Arc en bois','Bouclier en fer'];
  
  print(listeObjet);
  print("Entrer un nouvel objet : "); 
  String obj = stdin.readLineSync(); 

  
  listeObjet.add(obj);
  listeObjet.sort();

  print(listeObjet);

  
  
}