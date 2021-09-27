import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_tasty/Appbar.dart';
import 'package:sweet_tasty/Order.dart';
import 'package:sweet_tasty/AddOrderFormPage.dart';
import 'DataPage.dart';
import 'Models.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart' as retryHttp;
import 'dart:convert' as convert;
import 'main.dart';


class OutputPage extends StatefulWidget {
  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {

  final List<Order> _addedOrders = <Order>[];
  List<Box> _addedBoxes = <Box>[];
  bool _waiting = false;
  final snackBarNoneinStock = SnackBar(content: Text('None of the products are in stock',style: TextStyle(color: Colors.red),), backgroundColor: Colors.white70,duration: Duration(seconds: 3));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar("Outgoing Stocks", 15.0),
      floatingActionButton: Padding(
        child:FloatingActionButton(onPressed: openAddOrdersForm, child: Icon(Icons.add, color: Colors.grey[600],size: 30), backgroundColor: Colors.pink[100], elevation: 8.0,),
        padding:const EdgeInsets.only(right: 2,bottom: 11.0),),
      body: ModalProgressHUD(child: Container(child: Center(child: OrdersList(_addedOrders, refreshState),),),
        inAsyncCall: _waiting, opacity: 0.5, progressIndicator: CircularProgressIndicator(strokeWidth: 6, valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[200]),),),
      persistentFooterButtons: [ElevatedButton.icon(
          onPressed: _addedOrders.isEmpty ? null :  () => findOrders(),
          //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal[600])),
          label: Text('Find Orders'), icon: Icon(CupertinoIcons.chevron_forward)),
        Text('                                  ')],
    );
  }

  Future openAddOrdersForm() async {
    // push a new route like you did in the last section
    //Stock newStock = await Navigator.of(context).push(
    List res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddOrderFormPage();
        },
      ),
    );
    // A null check, to make sure that the user didn't abandon the form.
    Order newOrder = res[0];
    Box newBox = res[1];
    if (newOrder != null) {
      // Add a newStock to our mock array.
      setState(() {
        _addedOrders.add(newOrder);
        _addedBoxes.add(newBox);
      });
    }
  }

  Future dummyFindOrders() async{
    var rng = Random();
    this._addedBoxes.forEach((box) { box.location = rng.nextInt(NUMBER_OF_LOCATIONS); box.shelf = rng.nextInt(NUMBER_OF_SHELFS)+1;});
    setState(() {
      _waiting = true;
    });
    await Future.delayed(Duration(seconds:2), () {
      setState(() {
        _waiting = false;
      });
    });
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return DataPage(this._addedBoxes, false);
            },
            fullscreenDialog: true
        ));
  }

  Future findOrders() async{
    setState(() {
      _waiting = true;
    });
    String args = "";
    this._addedOrders.forEach((order) {
      args += 'ids=' + order.name + '&quantity=' + order.quantity.toString() + '&';
    });
    args = args.substring(0, args.length-1); //trimming the last &
    print(args);
    final client = retryHttp.RetryClient(http.Client());
    List<Box> itemsToRemoveByOrder = <Box>[];
    try {
      var response = await client.post(Uri.parse('http://' + getIP() + ':5000/remove' + '?' + args));
      if(response.statusCode==200) {
        if(response.body == "None exist"){
          ScaffoldMessenger.of(context).showSnackBar(snackBarNoneinStock);
          return;
        } else {
          var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
          jsonResponse.forEach((key, object) { //key is index starting from 0
            itemsToRemoveByOrder.add(Box(name: object['id'].toString(),
                q: object['q'],
                location: object['location'],
                shelf: object['shelf']));
          });
        }
      }
    } finally {
      setState(() {
        _waiting = false;
      });
      client.close();
    }
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return DataPage(itemsToRemoveByOrder, false);
            },
            fullscreenDialog: true
        ));
  }

  refreshState(int index) {
    setState(() {
      this._addedOrders.removeAt(index);
    });
  }

}


