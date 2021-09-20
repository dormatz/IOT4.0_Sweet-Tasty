import 'package:flutter/material.dart';
import 'package:sweet_tasty/Order.dart';
import 'Models.dart';
import 'Dashboard.dart' as dashboard;

class AddOrderFormPage extends StatefulWidget {
  @override
  _AddOrderFormPageState createState() => _AddOrderFormPageState();
}

class _AddOrderFormPageState extends State<AddOrderFormPage> {

  final nameController = TextEditingController();
  final qController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    qController.dispose();
    super.dispose();
  }

  void returnCreatedOrder(){
    if (_formKey.currentState.validate()) {
      Order newOrder = new Order(nameController.text, int.parse(qController.text));
      Box newBox = new Box(name: nameController.text, q: int.parse(qController.text));
      Navigator.of(context).pop([newOrder, newBox]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Order'),
        backgroundColor: Colors.black87,
      ),
      body: Form(key: _formKey, child:Container(
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
                child: TextFormField(decoration: InputDecoration(labelText: 'ID',), autofocus: true, controller: nameController, validator: dashboard.validator,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  controller: qController,
                  validator: dashboard.validator,
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
                    return ElevatedButton(onPressed: returnCreatedOrder,
                        style: ElevatedButton.styleFrom(primary: Colors.green), child: Text('Add Order'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
