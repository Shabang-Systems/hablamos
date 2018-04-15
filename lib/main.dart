import 'package:flutter/material.dart';

// Instantiates and runs main application
void main() {
  runApp(new Hablamos());
}

// Base app framework as a stateless widget
class Hablamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // Overrides abstract build() method
    return new MaterialApp(
      title: "Hablamos", // Sets title
      home: new HomeScreen(), // Sets home screen as a stateless widget defined below
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red[400],
          secondaryHeaderColor: Colors.redAccent[500],
          accentColor: Colors.redAccent[300],
      ),
    );
  }
}

// HomeScreen base stateful controller
class HomeScreen extends StatefulWidget {
  @override
  State createState() => new HomeScreenBaseState();
}

class HomeScreenBaseState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold( // App Scaffold
      appBar: new AppBar(title: new Text("Hablamos")), // App Bar
    );
  }
}