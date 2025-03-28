import 'package:dart_test/dart_test.dart';
import 'package:test/test.dart';
import 'dart:math';
void main() {
  //   test commentaire
 /*
  * 
  * 
  * 
  * 
  * 
  */
  //une liste de course
  List<String> course = ['carotte','brocolis','cookies'];
  
  var uneVariable = "test mon code";
    print(uneVariable);
  
  //appel function
  fonctionName("Jerome");

  var troisiemeElement = course.elementAt(2);
  print('element trois : $troisiemeElement');


  //random
  var max = 40;
  var min = 10;

  //random function 
  //import 'dart:math'; //import
  var number = Random().nextInt(40 - 10); // max - min
  print(number);


  course[2]='cookies au chocolat';
  troisiemeElement = course[2];
  print('element 3 : $troisiemeElement');
  
// //boucle for  
//   for(int i=0;i<course.length;i++){
//     print(course[i]);
    
//     //if condition
//     if(course[i] == 'brocolis'){
//      print('coucou'); 
//     }

//     //switch
//     switch(course[i]){
//       case 'carotte':print('test1');break;
//       case 'brocolis':print('salut');break;

//       default : print('aucune course');
//     }



//   }



}

//function 
void fonctionName(String name){
  print('Bonjour $name');
}