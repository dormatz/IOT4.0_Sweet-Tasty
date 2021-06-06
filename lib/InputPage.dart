import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_tasty/AddStockFormPage.dart';
import 'package:sweet_tasty/Stock.dart';
import 'package:sweet_tasty/Appbar.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  final List<Stock> _addedStocks = <Stock>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar("Incoming Stock", 27.0),
      floatingActionButton: FloatingActionButton(onPressed: openAddStockForm, child: Icon(Icons.add, color: Colors.grey[600]), backgroundColor: Colors.pink[100]),
      body: Container(child: Center(child: StocksList(_addedStocks),),),
      persistentFooterButtons: [ElevatedButton.icon(
                                  onPressed: _addedStocks.isEmpty ? null :  () => arrangeStocks(),
                                  //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal[600])),
                                  label: Text('Arrange in warehouse'), icon: Icon(Icons.house_siding_rounded)),
                                Text('                       ')],
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
      print(newStock);
    }
  }

  Future arrangeStocks() async{
    return;
  }

}
