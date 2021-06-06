import 'package:flutter/material.dart';
import 'package:sweet_tasty/Appbar.dart';

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
  int occupany_rate = 40;
  final _1Controller = TextEditingController();
  final _2Controller = TextEditingController();
  final _3Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[

          Padding(padding: EdgeInsets.all(20)),
          ListTile(title: Row(children: [Text("Occupancy rate is  ", style: TextStyle(fontSize: 30, color: Colors.brown[600]),),Text(occupany_rate.toString() + '%', style: occupanyRateStyle(context))])),
          Padding(padding: EdgeInsets.all(20)),
          Divider(),
          Center(child: Text('Queries on the database:', style: TextStyle(fontSize: 26, color: Colors.teal[600]),),),
          Padding(padding: EdgeInsets.all(20)),
          Container(
            child: TextField(decoration: textFieldsStyle("Quantity check", 'Product name..'), onSubmitted: getQuantity(_1Controller.text) , controller: _1Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          Padding(padding: EdgeInsets.all(30)),

          Container(
            child: TextField(decoration: textFieldsStyle("Position check", 'Product name..'), onSubmitted: getPosition(_2Controller.text) , controller: _2Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          Padding(padding: EdgeInsets.all(30)),

          Container(
            child: TextField(decoration: textFieldsStyle('Expiration date check', "Product name or 'All' for all products"), onSubmitted: getExpired(_3Controller.text) , controller: _3Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),

          //shelf query

          //list of items which are about to pass their expiration date
       ]); }

  TextStyle occupanyRateStyle(BuildContext context) {
    // TODO: change color based on value.
    return TextStyle(color: Colors.green, fontSize: 50, letterSpacing: 3,fontWeight: FontWeight.w500);
  }

  InputDecoration textFieldsStyle(labelText, hintText) {
    return InputDecoration(labelText: labelText,
      labelStyle: TextStyle(color: Colors.brown[600], fontSize: 20),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 20),
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

  getQuantity(String item) {
    return;
  }
  getPosition(String item) {
    return;
  }
  getExpired(String item) {
    return;
  }

}



