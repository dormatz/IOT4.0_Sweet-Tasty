import 'package:cloud_firestore/cloud_firestore.dart';
import 'Models.dart';

class DatabaseService {

  DatabaseService();

  final CollectionReference boxesCollection = FirebaseFirestore.instance.collection('boxes');

  //totalQuantityByName
  Future totalQuantity(String name) async {
    var total = 0;
    await boxesCollection.where('name', isEqualTo: name).get().
    then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        Box box = Box(name:doc['name'], q:doc['q'], shelf:doc['shelf']);
        total = total + box.q;
      })
    });
    return total;
  }

  //listOfLocationsByName
  Future getShelfs(String name) async {
    List<int> shelfs = [];
    await boxesCollection.where('name', isEqualTo: name).get().
    then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        print(doc['shelf']);
        shelfs.add(doc['shelf']);
      })
    });
    return shelfs;
  }
  //CloseToExpired

  //CloseToexpiredByName
}


//Boxes(name, q, shelf, expiration_date)