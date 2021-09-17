import 'package:flutter/material.dart';
import 'package:sweet_tasty/Stock.dart';
import 'package:sweet_tasty/Models.dart';
import 'Dashboard.dart' as dashboard;

class AddStockFormPage extends StatefulWidget {
  @override
  _AddStockFormPageState createState() => _AddStockFormPageState();
}

class _AddStockFormPageState extends State<AddStockFormPage> {

  final nameController = TextEditingController();
  final numController = TextEditingController(text: "1");
  final qController = TextEditingController();
  DateTime dateController;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    numController.dispose();
    qController.dispose();
    super.dispose();
  }

  void returnCreatedStock(){
    if (_formKey.currentState.validate()) {
      int numBoxes = int.parse(numController.text);
      int quantity = int.parse(qController.text);
      String name = nameController.text;
      Stock newStock = new Stock(name, numBoxes, quantity);
      List<Box> newBoxes = [];
      for (int i = 0; i < numBoxes; i++) {
        Box newBox = new Box(name: name /*+ '_' + (i + 1).toString()*/,
            q: quantity,
            expiration_date: dateController);
        newBoxes.add(newBox);
      }

      Navigator.of(context).pop([newStock, newBoxes]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Stock'),
        backgroundColor: Colors.black87,
      ),
      body: Form(key:_formKey,
        child: Container(
        color: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                // Text Field is the basic input widget for Flutter.
                // It comes built in with a ton of great UI and
                // functionality, such as the labelText field you see below.
                child: TextFormField(decoration: InputDecoration(labelText: 'Name or ID',), autofocus: true, controller: nameController, validator: dashboard.validator,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: TextFormField(decoration: InputDecoration(labelText: "Number of Containers",),controller: numController, validator: dashboard.validator,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity in every container'),
                  keyboardType: TextInputType.number,
                  controller: qController,
                  validator: dashboard.validator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: InputDatePickerFormField(initialDate: DateTime.now().add(Duration(days:300)), firstDate: DateTime.now(), lastDate: DateTime(2030), onDateSubmitted: (date) {dateController=date;},)
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
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
    ));
  }
}
