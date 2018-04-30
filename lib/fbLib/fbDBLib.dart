import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:async';

class Audio {
  String path;
  List<int> audioBytes;
  File audioFile;
  String uid;
  String collectionName;
  List<double> locale;
  CollectionReference collection;

  Audio(String path, List<double> locale, String uid,
      [collectionName = "community"]) {
    this.path = path;
    this.uid = uid;
    this.collectionName = collectionName;
    this.collection = Firestore.instance.collection(collectionName);
    this.audioFile = File(path);
    this.locale = locale;
  }

  Future<Map<String, dynamic>> get serializedData async {
    this.audioBytes = audioFile.readAsBytesSync();
    return {
      'audio': List.from(this.audioBytes),
      'locale': new GeoPoint(this.locale[0], this.locale[1]),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'uid': this.uid,
    };
  }

  static Future<Audio> createAudio(Map<String, dynamic> dbMap, [collectionName = "community"]) async {
    final directory = await getTemporaryDirectory();
    final uuidMaker = new Uuid();
    String audPath = directory.path+"/"+"hbAud_"+uuidMaker.v1()+".aac";
    List<int> audioBytes = new List();
    for (var i in dbMap["audio"]) {audioBytes.add(i);}
    final audFile = new File(audPath);
    audFile.writeAsBytesSync(audioBytes);
    return new Audio(audPath, [dbMap["locale"].latitude, dbMap["locale"].longitude], dbMap["uid"], collectionName);
  }
}

class DatabaseInstance{
  String collectionName;
  CollectionReference collection;

  DatabaseInstance([collectionName="community"]){
    this.collectionName = collectionName;
    this.collection = Firestore.instance.collection(collectionName);
  }

  Stream<QuerySnapshot> audioStream({int limit, int offset}) {
    Stream<QuerySnapshot> snapshots = collection.snapshots;
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  void delete(String id) async {
    collection.document(id).delete();
  }

  void add(Audio aud) async {
    collection.document().setData(await aud.serializedData);
  }
}
