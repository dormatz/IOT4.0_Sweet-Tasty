import 'package:flutter/material.dart';
import 'package:sweet_tasty/Stock.dart';

class AddStockFormPage extends StatefulWidget {
  @override
  _AddStockFormPageState createState() => _AddStockFormPageState();
}

class _AddStockFormPageState extends State<AddStockFormPage> {

  final nameController = TextEditingController();
  final numController = TextEditingController(text: "1");
  final qController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    numController.dispose();
    qController.dispose();
    super.dispose();
  }

  void returnCreatedStock(){
    Stock newStock = new Stock(nameController.text, int.parse(numController.text), int.parse(qController.text));
    Navigator.of(context).pop(newStock);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Stock'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                // Text Field is the basic input widget for Flutter.
                // It comes built in with a ton of great UI and
                // functionality, such as the labelText field you see below.
                child: TextField(decoration: InputDecoration(labelText: 'Name of item',), autofocus: true, controller: nameController,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(decoration: InputDecoration(labelText: "Number of Containers",),controller: numController,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Quantity in every container'),
                  keyboardType: TextInputType.number,
                  controller: qController,
                ),
              ),
              // A Strange situation.
              // A piece of the app that you'll add in the next
              // section *needs* to know its context,
              // and the easiest way to pass a context is to
              // use a builder method. So I've wrapped
              // this button in a Builder as a sort of 'hack'.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return ElevatedButton(onPressed: returnCreatedStock,
                        style: ElevatedButton.styleFrom(primary: Colors.green), child: Text('Add Stock'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
