import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Appbar.dart';
import 'Models.dart';


class ExpiredDataPage extends StatefulWidget {
  final List<Box> expiredBoxes;
  ExpiredDataPage(this.expiredBoxes);

  @override
  State<ExpiredDataPage> createState() => ExpiredDataPageState(expiredBoxes);
}

class ExpiredDataPageState extends State<ExpiredDataPage> {
  final List<Box> expiredBoxes;
  int numItems = 0;
  List<bool> selected = [];


  ExpiredDataPageState(this.expiredBoxes);

  @override
  void initState() {
    this.numItems = expiredBoxes.length;
    this.selected = List<bool>.generate(numItems, (int index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar('', 1.0),
      body: locationsDataTable(this.expiredBoxes, context, this.selected, this.numItems, setState),
    );
  }
}

SingleChildScrollView locationsDataTable(List<Box> boxes,BuildContext context, selected, numItems, setState) {
  List<DataRow> rows = [];
  boxes.asMap().forEach((index,box) {
    rows.add(DataRow(
        cells: [
          DataCell(Text(box.name)),
          DataCell(Text(box.location.toString())),
          DataCell(Text(box.shelf.toString())),
          DataCell(Text(box.expiration_date.toString()))
        ],
        color: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey.withOpacity(0.2);
              }
              return null; // Use default value for other states and odd rows.
            }
        ),
        onSelectChanged: (bool value){ setState(()  {selected[index]=value;} );},
        selected: selected[index]
    ));
  });
  return SingleChildScrollView(child: DataTable(
    columns: [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Location')),
      DataColumn(label: Text('Shelf')),
      DataColumn(label: Text('Expiration date'))
    ],
    rows: rows,
    columnSpacing: 15,
    showBottomBorder: true,
    showCheckboxColumn: true,
    horizontalMargin: 10,
    //headingRowColor: MaterialStateProperty.all(Colors.teal[100]),
    headingTextStyle: TextStyle(fontSize: 18, color: Colors.black),
  )
  );
}