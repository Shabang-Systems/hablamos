import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';


class ChatScreen extends StatefulWidget {
  final String id, name, description;
  ChatScreen(this.id, this.name, this.description);

  @override
  State createState() => new ChatScreenState(id, name, description);
}

class ChatScreenState extends State<ChatScreen> {
  final String id, name, description;
  final Uuid uuid = new Uuid();

  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String currentTopic = "!EMPTY!";
  ChatScreenState(this.id, this.name, this.description);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future _initialize() async{

    return;
  }

  @override
  Widget build(BuildContext context){
    _initialize();
    return new Scaffold(
      appBar: new AppBar(title: new Text(id)),
      body: new Center(
        child: new FloatingActionButton(
          onPressed: () {
          },
          child: new Text('Do Audio Thiny'),
        ),
      ),
    );
  }
}