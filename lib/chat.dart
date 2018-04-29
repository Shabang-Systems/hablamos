import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayer.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:uuid/uuid.dart';
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
  final AudioPlayer audioPlayer = new AudioPlayer();
  final uuidMaker = new Uuid();
  Recording _recording = new Recording();
  bool _isRecording = false;
  var recAddr = "!EMPTY!";

  String currentTopic = "!EMPTY!";
  ChatScreenState(this.id, this.name, this.description);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
//    print(recording.path);
//    await audioPlayer.play(recording.path);

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
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e){
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;
    audioPlayer.play(recAddr);
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
  }

  @override
  Widget build(BuildContext context){
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