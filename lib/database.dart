import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweet_tasty/constants.dart';
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
  Future getLocationsShelfs(String name) async {
    List<List<int>> locations_and_shelfs = [];
    await boxesCollection.where('name', isEqualTo: name).get().
    then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        locations_and_shelfs.add([doc['location'], doc['shelf']]);
      })
    });
    return locations_and_shelfs;
  }


  //CloseToExpired
  Future getAboutToExpire() async {
    List<Box> expired = [];
    await boxesCollection.where('expiration_date', isLessThan: Timestamp.fromDate(DateTime.now().add(Duration(days: DAYS_OF_CLOSE_TO_EXPIRATION)))).get()
        .then((querysnapshot)=> {
           querysnapshot.docs.forEach((doc) {
             print(doc.data());
             expired.add(Box(name:doc['name'], q: doc['q'], location:doc['location'], shelf:doc['shelf'], expiration_date: doc['expiration_date'].toDate()));
           })
        });
    return expired;
  }

  Future getAboutToExpireByName(String name) async {
    List<Box> expired = [];
    await boxesCollection.where('expiration_date', isLessThan: Timestamp.fromDate(DateTime.now().add(Duration(days: DAYS_OF_CLOSE_TO_EXPIRATION)))).get()
        .then((querysnapshot)=> {
      querysnapshot.docs.forEach((doc) {
        if(doc['name']==name) {
          expired.add(Box(name: doc['name'], q: doc['q'], location: doc['location'],shelf: doc['shelf'], expiration_date: doc['expiration_date'].toDate()));
        }
      })
    });
    return expired;
  }

  Future<int> getBoxesCount() async {
    int count = await boxesCollection.get()
        .then((querySnapshot) {
          return querySnapshot.docs.length;
    });
    return count;
  }
}
