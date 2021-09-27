import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stock {
  final String name;
  final int numOfBoxes;
  final int qInEachBox;
  final DateTime expiration_date;

  Stock(this.name, this.numOfBoxes, this.qInEachBox, [this.expiration_date=null]);

  @override
  String toString(){
    return "Stock(id: $name, numOfBoxes: $numOfBoxes, qInEach: $qInEachBox, exp_date: $expiration_date)";
  }
}

/*
class StockCard extends StatefulWidget {
  final Stock stock;
  final int index;
  final List<Stock> stocks;

  StockCard(this.stock, this.index, this.stocks);

  @override
  _StockCardState createState() => _StockCardState(stock, index, stocks);
}

class _StockCardState extends State<StockCard> {
  Stock stock;
  int index;
  List<Stock> stocks;

  _StockCardState(this.stock, this.index, this.stocks);

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(
      title: Text(widget.stock.name),
      subtitle: Text('Number of boxes: ' + widget.stock.numOfBoxes.toString() + ' each box holds: ' + widget.stock.qInEachBox.toString()),
      trailing: GestureDetector(onTap: () {setState(() {stocks.removeAt(index); print(index);});}, child: Icon(CupertinoIcons.trash)),
    ));
  }
}
*/

class StocksList extends StatefulWidget {
  // Builder methods rely on a set of data, such as a list.
  final List<Stock> stocks;
  final Function(int) notifyParent;

  StocksList(this.stocks, this.notifyParent);

  @override
  _StocksListState createState() => _StocksListState(stocks);
// First, make your build method like normal.
// Instead of returning Widgets, return a method that returns widgets.
// Don't forget to pass in the context!
}

class _StocksListState extends State<StocksList> {
  List<Stock> stocks;

  _StocksListState(this.stocks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: stocks.length,
      // A callback that will return a widget.
      itemBuilder: (context, index) {
        // In our case, a DogCard for each doggo.
        //return StockCard(stocks[index],index ,stocks);
        return Card(child: ListTile(
          title: Text(getTitle(index)),
          subtitle: Text('Number of boxes: ' + widget.stocks[index].numOfBoxes.toString() + '  each box holds: ' + widget.stocks[index].qInEachBox.toString()),
          trailing: GestureDetector(onTap: () { widget.notifyParent(index);}, child: Icon(CupertinoIcons.trash)),
        ));
      },
    );
  }

  String getTitle(index){
    int id = int.tryParse(widget.stocks[index].name);
    if(id != null) { //then its an ID
      return id.toString(); // if i have time change this to the hebrew name from the csv mapping.
    }else{
      return widget.stocks[index].name;
    }
  }
}




