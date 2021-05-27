import 'package:flutter/material.dart';
import 'package:sweet_tasty/Dashboard.dart';
import 'package:sweet_tasty/InputPage.dart';
import 'package:sweet_tasty/OutputPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home:  MainNavBar(),
    );
  }
}

class MainNavBar extends StatefulWidget {
  //MainNavBar({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  _MainNavBarState createState() => _MainNavBarState();
}

class  _MainNavBarState extends State<MainNavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [DashboardPage(), InputPage(), OutputPage()];

  void onTappedNavBar(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedNavBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: "input"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "output")
        ],
      ),
    );
  }
}
