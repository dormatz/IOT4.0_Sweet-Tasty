import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweet_tasty/constants.dart';
import 'Models.dart';

class DatabaseService {

  DatabaseService();

  final CollectionReference boxesCollection = FirebaseFirestore.instance.collection('storage');

  //totalQuantityByName
  Future totalQuantity(String id) async {
    var total = 0;
    await boxesCollection.where('id', isEqualTo: int.parse(id)).get().
    then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        //Box box = Box(name:doc['name'], q:doc['q'], shelf:doc['shelf']);
        total = total + doc.get('quantity');
      })
    });
    return total;
  }

  //listOfLocationsByName
  Future getDataByID(String id) async {
    List<Box> data = [];
    await boxesCollection.where('id', isEqualTo: int.parse(id)).get().
    then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        data.add(Box(name:id.toString(),q:doc['quantity'], location:doc['location'], shelf:doc['shelf'], expiration_date: doc['expiration_date'].toDate()));
      })
    });
    return data;
  }


  //CloseToExpired
  Future getAboutToExpire() async {
    List<Box> expired = [];
    await boxesCollection.where('expiration_date', isLessThan: Timestamp.fromDate(DateTime.now().add(Duration(days: DAYS_OF_CLOSE_TO_EXPIRATION)))).get()
        .then((querysnapshot)=> {
           querysnapshot.docs.forEach((doc) {
             print(doc.data());
             expired.add(Box(name:doc['id'].toString(), q: doc['quantity'], location:doc['location'], shelf:doc['shelf'], expiration_date: doc['expiration_date'].toDate()));
           })
        });
    return expired;
  }

  Future getAboutToExpireByName(String id) async {
    List<Box> expired = [];
    await boxesCollection.where('expiration_date', isLessThan: Timestamp.fromDate(DateTime.now().add(Duration(days: DAYS_OF_CLOSE_TO_EXPIRATION)))).get()
        .then((querysnapshot)=> {
      querysnapshot.docs.forEach((doc) {
        if(doc['id']==int.parse(id)) {
          expired.add(Box(name: doc['id'].toString(), q: doc['quantity'], location: doc['location'],shelf: doc['shelf'], expiration_date: doc['expiration_date'].toDate()));
          print('found');
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
