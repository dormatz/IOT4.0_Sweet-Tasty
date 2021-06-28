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


class OutputPage extends StatefulWidget {
  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {

  final List<Order> _addedOrders = <Order>[];
  List<Box> _addedBoxes = <Box>[];
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar("Outgoing Stocks", 22.0),
      floatingActionButton: Padding(
        child:FloatingActionButton(onPressed: openAddOrdersForm, child: Icon(Icons.add, color: Colors.grey[600],size: 30), backgroundColor: Colors.pink[100], elevation: 8.0,),
        padding:const EdgeInsets.only(right: 2,bottom: 11.0),),
      body: ModalProgressHUD(child: Container(child: Center(child: OrdersList(_addedOrders),),),
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

  Future findOrders() async{
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

}


