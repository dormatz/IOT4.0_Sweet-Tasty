import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sweet_tasty/Appbar.dart';
import 'package:sweet_tasty/database.dart';
import 'ExpiredDataPage.dart';
import 'Models.dart';
import 'constants.dart';
import 'main.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar('Dashboard', 44.0),
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
  int fake_occupancy_rate = 47;
  final _1Controller = TextEditingController();
  final _2Controller = TextEditingController();
  final _3Controller = TextEditingController();
  final db = DatabaseService();
  final _firstKey = GlobalKey<FormFieldState>();
  final _secondKey = GlobalKey<FormFieldState>();
  bool _waiting = false;
  bool isVisible = false;

  @override
  void initState() {
    this.getOccupancy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _waiting, opacity: 0.5, progressIndicator: CircularProgressIndicator(strokeWidth: 6, valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[200]),),
        child:ListView(
          children: <Widget>[

          Padding(padding: EdgeInsets.all(20)),
          ListTile(title: Row(children: [Text("Occupancy rate is  ", style: TextStyle(fontSize: 30, color: Colors.brown[600]),),Text(real_occupancy_rate.toString() + '%', style: occupanyRateStyle(context))])),
          Padding(padding: EdgeInsets.all(20)),
          Divider(),
          Center(child: Text('Queries on the database:', style: TextStyle(fontSize: 26, color: Colors.teal[600]),),),
          Padding(padding: EdgeInsets.all(20)),
          Container(
            child: TextFormField(key:_firstKey, decoration: textFieldsStyle("Quantity check", 'Product ID..', getQuantity, _1Controller), controller: _1Controller, validator: validator,),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          Padding(padding: EdgeInsets.all(30)),

          Container(
            child: TextFormField(key: _secondKey, decoration: textFieldsStyle("Location check", 'Product ID..', getPosition, _2Controller) , controller: _2Controller, validator: validator,),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
          Padding(padding: EdgeInsets.all(30)),

          Container(
            child: TextField(decoration: textFieldsStyle('Expiration date check', "ID or leave empty for all products", getExpired, _3Controller) , controller: _3Controller),
            margin: EdgeInsets.only(right: 10, left: 10),
          ),
       ]
    )
    );
  }

  TextStyle occupanyRateStyle(BuildContext context) {
    // TODO: change color based on value.
    return TextStyle(color: Colors.green, fontSize: 50, letterSpacing: 3,fontWeight: FontWeight.w500);
  }

  InputDecoration textFieldsStyle(labelText, hintText, query, ctrl) {
    return InputDecoration(labelText: labelText,
      labelStyle: TextStyle(color: Colors.brown[600], fontSize: 20),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
      suffixIcon: IconButton(onPressed: () => query(ctrl.text), icon: Icon(Icons.arrow_forward_outlined)),
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
    if(_firstKey.currentState.validate()) {
      await this.Loading();
      print(item);
      int Q = await db.totalQuantity(item); //in the real deal the totalQuantity will be called inside Loading
      //print(Q);
      //print(item);
      showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              CupertinoAlertDialog(
                title: Text("Quantity of " + item),
                content: Column(children: [
                          Padding(padding: EdgeInsets.all(10)),
                          Text(Q.toString(),style: TextStyle(fontSize: 30, color: Colors.teal[600]))
                ],),
                  actions: [TextButton(child: Text('Dismiss',style: TextStyle(fontSize: 16, color: Colors.lightBlue),), onPressed: () {
                  Navigator.of(context).pop();
                },)
                ],
              )
      );
    }
  }


  Future getPosition(String item) async {
    if(_secondKey.currentState.validate()) {
      await this.Loading();
      List<Box> data = await db.getDataByID(item);
      print(data);
      if (data.isEmpty) {
        await showCupertinoModalPopup(
            context: context,
            barrierDismissible: true,
            builder: (context) =>
                CupertinoActionSheet(message: Text("The warehouse doesn't contain any units of this product", style: TextStyle(fontSize: 18, color: Colors.redAccent),),
                  cancelButton: CupertinoActionSheetAction(child: Text('Dismiss', style: TextStyle(color:Colors.lightBlue),), onPressed: () => {Navigator.of(context).pop()},),)
        );
        return;
      }
      await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) {
                return ExpiredDataPage(data);
              },
              fullscreenDialog: true
          ));
    }
  }

  getExpired(String item) async {
    if (item.startsWith('ip')){
       if (item == 'ip default'){
         setIP('10.0.2.2', context);
         return;
       }
       setIP(item.split(' ')[1], context);
       return;
    }
    List<Box> expired;
    await this.Loading();
    if(item.isEmpty){
      expired = await db.getAboutToExpire();
    }else{
      print(item);
      expired = await db.getAboutToExpireByName(item);
    }
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

  Future Loading() async {// with real server request, this method should get the API
    print('ss');
    setState(() {
      _waiting = true;
    });
    await Future.delayed(Duration(seconds:1), () {
      setState(() {
        _waiting = false;
      });
    });
  }

}

String validator(String value) {
  if (value == null || value.isEmpty){
    return "Field can't be empty";
  }
  return null;
}
