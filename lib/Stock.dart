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


class StockCard extends StatefulWidget {
  final Stock stock;

  StockCard(this.stock);

  @override
  _DogCardState createState() => _DogCardState(stock);
}

class _DogCardState extends State<StockCard> {
  Stock stock;

  _DogCardState(this.stock);

  @override
  Widget build(BuildContext context) {
    return Row(
            children: <Widget>[Expanded(child: Text(widget.stock.name)), Expanded(child: Text(widget.stock.numOfBoxes.toString())), Expanded(child: Text(widget.stock.qInEachBox.toString()))]
    );
  }
}


class StocksList extends StatelessWidget {
  // Builder methods rely on a set of data, such as a list.
  final List<Stock> stocks;
  StocksList(this.stocks);

  // First, make your build method like normal.
  // Instead of returning Widgets, return a method that returns widgets.
  // Don't forget to pass in the context!
  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  // A builder method almost always returns a ListView.
  // A ListView is a widget similar to Column or Row.
  // It knows whether it needs to be scrollable or not.
  // It has a constructor called builder, which it knows will
  // work with a List.

  ListView _buildList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: stocks.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, a DogCard for each doggo.
        return StockCard(stocks[int]);
      },
    );
  }
}