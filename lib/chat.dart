import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String id, name, description;
  ChatScreen(this.id, this.name, this.description);

  @override
  State createState() => new ChatScreenState(id, name, description);
}

class ChatScreenState extends State<ChatScreen> {
  final String id, name, description;
  ChatScreenState(this.id, this.name, this.description);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(id),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('Go back!'),
        ),
      ),
    );
  }
}