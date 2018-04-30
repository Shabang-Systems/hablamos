import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'lib/fbLib/fbAuthLib.dart';
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

// --------------------------
//var key = AuthenticationKey();
//key.createAccount("liuhoujun15@gmail.com", "test123");
//key.fbUser


// -------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class AudioItem{
  FirebaseUser user;
  var audioObject;
  var locale;
  var timeStamp;
  var uid;

  Map<String, dynamic> toMap() => {
    'audio': this.audioObject,
    'locale': this.locale,
    'timestamp': this.timeStamp,
    'uid': this.uid,
  };

  static AudioItem fromMap(Map<String, dynamic> map) {
    AudioItem _obj = AudioItem();
    _obj.audioObject = map['audio'];
    _obj.locale = map['locale'];
    _obj.timeStamp = map['timestamp'];
    _obj.uid = map['uid'];
    return _obj;
  }
}

class Audio{
  String path;
  List<int> audioBytes;
  File audioFile;
  FirebaseUser user;
  String collectionName;
  List<double> locale;
  CollectionReference collection;

  Audio(String path, List<double> locale, FirebaseUser user, [collectionName="community"]){
    this.path = path;
    this.user = user;
    this.collectionName = collectionName;
    this.collection = Firestore.instance.collection(collectionName);
    this.audioFile = File(path);
    this.locale = locale;
  }

  Future<Map<String, dynamic>> _generateDI() async {
    this.audioBytes = await audioFile.readAsBytes();
    return {
      'audio': this.audioBytes,
      'locale': new GeoPoint(this.locale[0], this.locale[1]),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'uid': this.user.uid,
    };
  }

  void create() async{
    var di = await _generateDI();
    final TransactionHandler transactionCreator = (Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(collection.document());
      await tx.set(newDoc.reference, di);
      return di;
    };
    print("as");
    print(di);
    print("sa");
  }

}