import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Order {
  final String name;
  final int quantity;

  Order(this.name, this.quantity);

  @override
  String toString(){
    return "Order(x: $name, quantity: $quantity)";
  }
}


class OrdersList extends StatefulWidget {
  // Builder methods rely on a set of data, such as a list.
  final List<Order> orders;
  final Function(int) notifyParent;
  OrdersList(this.orders, this.notifyParent);

  @override
  _OrdersListState createState() => _OrdersListState(orders);
// First, make your build method like normal.
// Instead of returning Widgets, return a method that returns widgets.
// Don't forget to pass in the context!
}

class _OrdersListState extends State<OrdersList> {
  List<Order> orders;

  _OrdersListState(this.orders);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: orders.length,
      // A callback that will return a widget.
      itemBuilder: (context, index) {
        // In our case, a DogCard for each doggo.
        //return StockCard(stocks[index],index ,stocks);
        return Card(child: ListTile(
          title: Text(widget.orders[index].name),
          subtitle: Text('Quantity: ' + widget.orders[index].quantity.toString()),
          trailing: GestureDetector(onTap: () {widget.notifyParent(index);}, child: Icon(CupertinoIcons.trash)),
        ));
      },
    );
  }
}