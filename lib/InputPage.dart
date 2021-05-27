import 'package:flutter/material.dart';
import 'package:sweet_tasty/AddStockFormPage.dart';
import 'package:sweet_tasty/Stock.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  final List<Stock> _addedStocks = <Stock>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Incoming stock")),
      floatingActionButton: FloatingActionButton(onPressed: openAddStockForm, child: Icon(Icons.add), backgroundColor: Colors.deepPurple),
      body: Container(child: Center(child: StocksList(_addedStocks),),),
    );
  }

  Future openAddStockForm() async {
    // push a new route like you did in the last section
    //Stock newStock = await Navigator.of(context).push(
    Stock newStock = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddStockFormPage();
        },
      ),
    );
    // A null check, to make sure that the user didn't abandon the form.
    if (newStock != null) {
      // Add a newStock to our mock array.
      setState(() {
        _addedStocks.add(newStock);
      });
      for (var val in _addedStocks){
        print(val);
      }
      print('*****************');
    }
  }
}
