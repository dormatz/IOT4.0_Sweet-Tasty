import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_tasty/AddStockFormPage.dart';
import 'package:sweet_tasty/DataPage.dart';
import 'package:sweet_tasty/Stock.dart';
import 'package:sweet_tasty/Appbar.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart' as retryHttp;
import 'dart:convert' as convert;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sweet_tasty/Models.dart';
import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sweet_tasty/main.dart';
import 'constants.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final List<Box> _addedBoxes = <Box>[];
  final List<Stock> _addedStocks = <Stock>[];
  bool _waiting = false;
  final snackBarFail = SnackBar(content: Text('Invalid barcode',style: TextStyle(color: Colors.red),), backgroundColor: Colors.white70,);
  final snackBarSuccess = SnackBar(content: Text('Success',style: TextStyle(color: Colors.green),), backgroundColor: Colors.white70,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar("Incoming Stock", 21.0),
      floatingActionButton: buildSpeedDial(),
      body: ModalProgressHUD(
          child: Container(child: Center(child: StocksList(_addedStocks),),),
          inAsyncCall: _waiting, opacity: 0.5, progressIndicator: CircularProgressIndicator(strokeWidth: 6, valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[200]),),),
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: _addedStocks.isEmpty ? null : () =>
              arrangeStocks(),
          //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal[600])),
          label: Text('Arrange in warehouse'),
          icon: Icon(Icons.house_siding_rounded)),
        Text('                       ')
      ],
    );
  }

  Future openAddStockForm() async {
    // push a new route like you did in the last section
    //Stock newStock = await Navigator.of(context).push(
    List res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddStockFormPage();
        },
      ),
    );
    Stock newStock = res[0];
    List<Box> newBoxes = res[1];
    // A null check, to make sure that the user didn't abandon the form.
    if (newStock != null) {
      // Add a newStock to our mock array.
      setState(() {
        _addedStocks.add(newStock);
        _addedBoxes.addAll(newBoxes);
      });
      print(newStock);
      print(newBoxes);
    }
  }

  Future dummyArrangeStocks() async {
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
              return DataPage(this._addedBoxes, true);
            },
            fullscreenDialog: true
        ));
  }

  Future arrangeStocks() async {
    setState(() {
      _waiting = true;
    });
    var start = DateTime.now();
    String args = "";
    this._addedBoxes.forEach((box) {
      args += 'ids=' + box.name + '&quantity=' + box.q.toString() + '&';
    });
    args = args.substring(0, args.length-1); //trimming the last &
    print(args);
    final client = retryHttp.RetryClient(http.Client());
    try {
      print('http://' + ip_address + ':5000/insert' + '?' + args);
      var response = await client.post(Uri.parse('http://' + ip_address + ':5000/insert' + '?' + args));
      if(response.statusCode==200) {
        print(response.body);
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        var orderTSP = [];
        jsonResponse.forEach((key, locShelfOrder) { //key is index starting from 0, locShelfOrder is a list[3] - location, shelf and order in TSP.
          print(key);
          print(key.runtimeType);
          this._addedBoxes[int.parse(key)].location = locShelfOrder[0];
          this._addedBoxes[int.parse(key)].shelf = locShelfOrder[1];
          orderTSP.add(locShelfOrder[2]);
        });
        reOrder(orderTSP);
      }
    } catch(e) {
      print(e);
    }
    finally {
      setState(() {
        _waiting = false;
      });
      print(start.difference(DateTime.now()).inSeconds);
      client.close();
    }
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return DataPage(this._addedBoxes, true);
            },
            fullscreenDialog: true
        ));
  }

  //currently not in use
  FloatingActionButton addButton() {
    return FloatingActionButton.extended(onPressed: openAddStockForm,
        icon: Icon(Icons.add, color: Colors.grey[600]),
        label: Text('Manually'),
        backgroundColor: Colors.pink[100]);
  }


  Future<void> scanBarcode() async{
    bool invalid = false;
    print('before');
    String barcodeScan = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    print('after');
    String name;
    int quantity;
    var expiration_date;
    print(barcodeScan);
    try{
      List<String> inputs = barcodeScan.split("@");
      name = inputs[0];
      print(inputs[0]);
      assert(inputs[1] != null, inputs[2]!= null);
      quantity = int.parse(inputs[1]);
      print(inputs[2]);
      expiration_date = DateTime.parse(inputs[2]);
      print(expiration_date);
      setState(() {
        _addedBoxes.add(Box(name: name, q: quantity, expiration_date: expiration_date));
        _addedStocks.add(Stock(name, 1, quantity));
      });
      print('created a box');
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
    }
    catch(e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
    }
    return invalid;
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      icon: Icons.add,
      activeIcon: Icons.cancel_outlined,
      iconTheme: IconThemeData(color: Colors.grey[600], size: 30),
      buttonSize: 70.0,
      visible: true,


      closeManually: false,
      curve: Curves.bounceIn,
      //overlayColor: Colors.black,
      //overlayOpacity: 0.5,
      backgroundColor: Colors.pink[100],
      elevation: 8.0,
      shape: CircleBorder(),
      //orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(Icons.keyboard),
          backgroundColor: Colors.pink[50],
          //label: 'Manual',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => openAddStockForm(),
        ),
        SpeedDialChild(
          child: Icon(Icons.camera_alt_outlined),
          backgroundColor: Colors.pink[50],
          //label: 'Scan',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => scanBarcode(),
        ),
      ],
    );
  }

  void reOrder(orderTSP) {
    var copyAddedBoxes = new List.from(this._addedBoxes);
    for(var i = 0; i< orderTSP.length; i++ ){
      this._addedBoxes[orderTSP[i]] = copyAddedBoxes[i];
    }
  }
}
