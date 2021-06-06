import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_tasty/Appbar.dart';
import 'package:sweet_tasty/Order.dart';
import 'package:sweet_tasty/AddOrderFormPage.dart';

class OutputPage extends StatefulWidget {
  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {

  final List<Order> _addedOrders = <Order>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar("Outgoing Stocks", 22.0),
      floatingActionButton: FloatingActionButton(onPressed: openAddOrdersForm, child: Icon(Icons.add, color: Colors.grey[600]), backgroundColor: Colors.pink[100]),
      body: Container(child: Center(child: OrdersList(_addedOrders),),),
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
    Order newOrder = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddOrderFormPage();
        },
      ),
    );
    // A null check, to make sure that the user didn't abandon the form.
    if (newOrder != null) {
      // Add a newStock to our mock array.
      setState(() {
        _addedOrders.add(newOrder);
      });
      print(newOrder);
      print(_addedOrders.isEmpty);
    }
  }

  Future findOrders() async{
    return;
  }

}


