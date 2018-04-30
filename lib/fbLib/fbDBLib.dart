import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:async';

class Audio {
  String path;
  List<int> audioBytes;
  File audioFile;
  FirebaseUser user;
  String collectionName;
  List<double> locale;
  CollectionReference collection;

  Audio(String path, List<double> locale, FirebaseUser user,
      [collectionName = "community"]) {
    this.path = path;
    this.user = user;
    this.collectionName = collectionName;
    this.collection = Firestore.instance.collection(collectionName);
    this.audioFile = File(path);
    this.locale = locale;
  }

  Future<Map<String, dynamic>> _generateDI() async {
    this.audioBytes = audioFile.readAsBytesSync();
    return {
      'audio': List.from(this.audioBytes),
      'locale': new GeoPoint(this.locale[0], this.locale[1]),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'uid': this.user.uid,
    };
  }

  void create() async {
    this.collection.document().setData(await _generateDI());
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
}
