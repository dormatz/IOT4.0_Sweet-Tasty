import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Appbar.dart';
import 'Models.dart';


class DataPage extends StatefulWidget {
 final List<Box> addedBoxes;
 final bool input;
 DataPage(this.addedBoxes, this.input);

  @override
  State<DataPage> createState() => DataPageState(addedBoxes, input);
}

class DataPageState extends State<DataPage> {
 final List<Box> addedBoxes;
 final bool input; //input or output
 int numItems = 0;
 List<bool> selected = [];


 DataPageState(this.addedBoxes, this.input);

 @override
  void initState() {
   this.numItems = addedBoxes.length;
   this.selected = List<bool>.generate(numItems, (int index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(1.0),
      body: locationsDataTable(this.addedBoxes, this.input, context, this.selected, this.numItems, setState),
    );
  }

 Widget _createAppBar(padding) {
   if (this.input) {
     return createAppBar('By order', padding);
   }else {
     return createAppBar('By order', padding);
   }
 }
}

SingleChildScrollView locationsDataTable(List<Box> boxes, bool input,BuildContext context, selected, numItems, setState) {
  List<DataRow> rows = [];
  if(input) {
    boxes.asMap().forEach((index,box) {
      rows.add(DataRow(
          cells: [
            DataCell(Text(box.name, style: TextStyle(fontSize: 18),), ),
            DataCell(Text(box.location.toString(), style: TextStyle(fontSize: 18))),
            DataCell(Text(box.shelf.toString(), style: TextStyle(fontSize: 18)))
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
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Shelf'))
      ],
      rows: rows,
      columnSpacing: 90,
      showBottomBorder: true,
      showCheckboxColumn: true,
      horizontalMargin: 10,
      //headingRowColor: MaterialStateProperty.all(Colors.teal[100]),
      headingTextStyle: TextStyle(fontSize: 18, color: Colors.black),
    )
    );
  }
  else{
    boxes.asMap().forEach((index, box) {
      rows.add(DataRow(
          cells: [
            DataCell(Text(box.name,style: TextStyle(fontSize: 18))),
            DataCell(Text(box.q.toString(),style: TextStyle(fontSize: 18))),
            DataCell(Text(box.location.toString(),style: TextStyle(fontSize: 18))),
            DataCell(Text(box.shelf.toString(),style: TextStyle(fontSize: 18)))
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
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Shelf'))
      ],
      rows: rows,
      columnSpacing: 31,
      showBottomBorder: true,
      showCheckboxColumn: true,
      horizontalMargin: 10,
      //headingRowColor: MaterialStateProperty.all(Colors.teal[100]),
      headingTextStyle: TextStyle(fontSize: 18, color: Colors.black),
    )
    );
  }
}

