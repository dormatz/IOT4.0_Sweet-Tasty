import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_tasty/Appbar.dart';
import 'package:sweet_tasty/database.dart';
import 'ExpiredDataPage.dart';
import 'Models.dart';
import 'constants.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar('Dashboard', 52.0),
      body: Container(child: DashboardListView(), decoration: myGradient()),
    );
  }
}

BoxDecoration myGradient() {
  return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blueGrey[100],
          Colors.grey[300],
          Colors.blueGrey[100],
        ],
      )
  );
}


class DashboardListView extends StatefulWidget {
  @override
  _DashboardListViewState createState() => _DashboardListViewState();
}

class _DashboardListViewState extends State<DashboardListView> {
  String real_occupancy_rate = '';
  int fake_occupancy_rate = 40;
  final _1Controller = TextEditingController();
  final _2Controller = TextEditingController();
  final _3Controller = TextEditingController();
  final db = DatabaseService();


  @override
  void initState() {
    this.getOccupancy();
    print('dsfdsf');
    print(real_occupancy_rate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[

          Padding(padding: EdgeInsets.all(20)),
          ListTile(title: Row(children: [Text("Occupancy rate is  ", style: TextStyle(fontSize: 30, color: Colors.brown[600]),),Text(real_occupancy_rate + '%', style: occupanyRateStyle(context))])),
          Padding(padding: EdgeInsets.all(20)),
          Divider(),
          Center(child: Text('Queries on the database:', style: TextStyle(fontSize: 26, color: Colors.teal[600]),),),
          Padding(padding: EdgeInsets.all(20)),
          Container(
            child: TextField(decoration: textFieldsStyle("Quantity check", 'Product name..', getQuantity, _1Controller.text), controller: _1Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          Padding(padding: EdgeInsets.all(30)),

          Container(
            child: TextField(decoration: textFieldsStyle("Location check", 'Product name..', getPosition, _2Controller.text) , controller: _2Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          Padding(padding: EdgeInsets.all(30)),

          Container(
            child: TextField(decoration: textFieldsStyle('Expiration date check', "Product name or 'All' for all products", getExpired, _3Controller.text) , controller: _3Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          //shelf query

          //list of items which are about to pass their expiration date
       ]); }

  TextStyle occupanyRateStyle(BuildContext context) {
    // TODO: change color based on value.
    return TextStyle(color: Colors.green, fontSize: 50, letterSpacing: 3,fontWeight: FontWeight.w500);
  }

  InputDecoration textFieldsStyle(labelText, hintText, query, ctrl) {
    return InputDecoration(labelText: labelText,
      labelStyle: TextStyle(color: Colors.brown[600], fontSize: 20),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
      suffixIcon: IconButton(onPressed: () => query(ctrl), icon: Icon(Icons.arrow_forward_outlined)),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Colors.blueGrey,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(
    color: Colors.pink[100],
    width: 3.5,
    ),
    ),
    );
  }

  Future getQuantity(String item) async {
    int Q = await db.totalQuantity(item);
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder:  (context) => CupertinoAlertDialog(
            title: Text("Quantity of " + item),
            content: Text(Q.toString()),
            actions: [TextButton(child:Text('Dismiss'), onPressed: () {Navigator.of(context).pop();},)],
        )
    );
  }


  Future getPosition(String item) async {
    List<int> sh = await db.getShelfs(item);
    String shelfs = '';
    Widget title;
    if (sh.isEmpty) {
      title = Text('There are not any ' + item + ' in the warehouse');
    }
    else {
      for (int s in sh) {
        shelfs = shelfs + s.toString() + ', ';
      }
      shelfs = shelfs.substring(0, shelfs.length - 2);
      title = Text(item + ' can be found in shelfs:');
    }
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder:  (context) => CupertinoAlertDialog(
          title: title,
          content: Text(shelfs),
          actions: [TextButton(child:Text('Dismiss'), onPressed: () {Navigator.of(context).pop();},)],
        )
    );
  }

  getExpired(String item) async {
    List<Box> expired = await db.getAboutToExpire();
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return ExpiredDataPage(expired);
            },
            fullscreenDialog: true
        ));
  }

  void getOccupancy() async {
    int count = await db.getBoxesCount();
    setState(() {
      this.real_occupancy_rate = (100*(count / (NUMBER_OF_LOCATIONS*NUMBER_OF_SHELFS))).ceil().toString();
      //this.occupancy_rate = 30;
    });
  }
}
