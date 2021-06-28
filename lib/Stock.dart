import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stock {
  final String name;
  final int numOfBoxes;
  final int qInEachBox;

  Stock(this.name, this.numOfBoxes, this.qInEachBox);

  @override
  String toString(){
    return "Stock(x: $name, numOfBoxes: $numOfBoxes, qInEach: $qInEachBox )";
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

  StocksList(this.stocks);

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
          title: Text(widget.stocks[index].name),
          subtitle: Text('Number of boxes: ' + widget.stocks[index].numOfBoxes.toString() + '  each box holds: ' + widget.stocks[index].qInEachBox.toString()),
          trailing: GestureDetector(onTap: () {setState(() {stocks.removeAt(index);});}, child: Icon(CupertinoIcons.trash)),
        ));
      },
    );
  }
}




