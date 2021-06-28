import 'package:flutter/material.dart';

Widget createAppBar(title, padding){
  Widget myAppBar = AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Text(title , style: TextStyle(color: Colors.brown[600], fontSize: 25)))
        ,
        Padding(
            padding: EdgeInsets.all(padding))
        ,
        Image.asset('logo-pink100.jpg',
          fit: BoxFit.contain,
          height: 50,
        )
      ],

    ),
    backgroundColor: Colors.pink[100],
  );
  return myAppBar;
}

