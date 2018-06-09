import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayer.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'fbLib/fbDBLib.dart';
import 'fbLib/fbAuthLib.dart';
import 'package:path/path.dart' as path;
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
  final uuidMaker = new Uuid();
  Recording _recording = new Recording();
  bool _isRecording = false;
  var recAddr = "!EMPTY!";

  String currentTopic = "!EMPTY!";
  ChatScreenState(this.id, this.name, this.description);

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  _start() async {
    String _currentPath = await _localPath+"/"+"taud"+uuidMaker.v1()+".aac";
    recAddr = _currentPath;
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_currentPath != null && _currentPath != "") {
          await AudioRecorder.start(path: _currentPath, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: _currentPath);
          _isRecording = isRecording;
        });
      } else {
        this._permissionDialog();
      }
    } catch (e){
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    var ie = AuthInstance();
    if(await ie.ensureLoggedIn()==1){
      ie.authenticate("liuhoujun15@gmail.com", "Liuhoujun@");
    }
    var a = Audio(recording.path, [0.0, 0.0], ie.user.uid);
    var di = FirebasePointer();
    di.add(a);
    bool isRecording = await AudioRecorder.isRecording;
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
  }

  _permissionDialog() async {
    await showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {return new AlertDialog(
      title: new Text('We need your permissions.'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('To help us better deliver the audio experience, we need your permissions.'),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Settings'),
          textColor: Colors.grey[600],
          onPressed: () {
            SimplePermissions.openSettings();
          },
        ),
        new FlatButton(
            child: new Text('Continue'),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ],
    );});
    await _requestAudioPermission();
    await _requestStoragePermission();
  }

  _requestAudioPermission() async {
    var res = await SimplePermissions.requestPermission(Permission.RecordAudio);
  }

  _requestStoragePermission() async {
    var res = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
  }

  getAndPlay(data) async {
    final AudioPlayer audioPlayer = new AudioPlayer();
    Audio audObj = await Audio.createAudio(data);
    final result = await audioPlayer.play(audObj.path, isLocal: true);
  }

  @override
  Widget build(BuildContext context){
    var di = FirebasePointer();
    var knownDocuments = [];
    di.audioStream().listen((QuerySnapshot q) {
      for (var i in q.documents){
        if (knownDocuments.contains(i.documentID)){
          continue;
        }
        knownDocuments.add(i.documentID);

        getAndPlay(i.data);
      }

    });
    return new Scaffold(
      appBar: new AppBar(title: new Text(id)),
      body: new Center(
        child: new FloatingActionButton(
          onPressed: () {
            if(_isRecording) {
              _stop();
            }
            else {
              _start();
            }
          },
          child: new Text('Do Audio Thiny'),
        ),
      ),
    );
  }
}