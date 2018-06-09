import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:async';

class Audio {
  String path;
  List<int> audioBytes;
  File audioFile;
  String uid;
  String uniqueId;
  String collectionName;
  List<double> locale;
  CollectionReference collection;

  Audio(String path, List<double> locale, String uid,
      [collectionName = "community"]) {
    this.path = path;
    this.uid = uid;
    this.uniqueId = Uuid().v1();
    this.collectionName = collectionName;
    this.collection = Firestore.instance.collection(collectionName);
    this.audioFile = File(path);
    this.locale = locale;
  }

  Future<Map<String, dynamic>> get serializedData async {
    this.audioBytes = audioFile.readAsBytesSync();
    return {
      'locale': new GeoPoint(this.locale[0], this.locale[1]),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'userid': this.uid,
    };
  }

  static Future<Audio> createAudio(Map<String, dynamic> dbMap, [collectionName = "community"]) async {
    final String downloadUriString = dbMap["dataurl"];

    final directory = await getTemporaryDirectory();
    final uuidMaker = new Uuid();
    final uniqueId = uuidMaker.v1();
    String audPath = directory.path+"/"+"hbAud_"+uniqueId+".aac";
    final audFile = new File(audPath);

    await http.get(downloadUriString).then((response) {
      audFile.writeAsBytesSync(response.bodyBytes);
    });

    var audObj = new Audio(audPath, [dbMap["locale"].latitude, dbMap["locale"].longitude], dbMap["userid"], collectionName);
    audObj.uniqueId = uniqueId;
    return audObj;
  }
}

class FirebasePointer{
  String collectionName;
  CollectionReference collection;
  FirebaseStorage storageInstance;
  StorageReference storageRefrence;

  FirebasePointer([collectionName="community"]){
    this.collectionName = collectionName;
    this.collection = Firestore.instance.collection(collectionName);
    this.storageInstance = new FirebaseStorage();
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
    final storageRefrence = storageInstance.ref().child('audFiles').child(aud.uniqueId);
    final StorageUploadTask uploadTask = storageRefrence.putFile(
      aud.audioFile,
    );
    final Uri downloadUri = (await uploadTask.future).downloadUrl;
    final String downloadUriString = downloadUri.toString();
    Map<String, dynamic> serializedData = await aud.serializedData;
    serializedData['dataurl'] = downloadUriString;
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(collection.document());
      await tx.set(newDoc.reference, serializedData);
      return serializedData;
    };

    await Firestore.instance.runTransaction(createTransaction).catchError((e) {
      print('dart error: $e');
    });


    collection.document(aud.uniqueId).setData(serializedData);
  }

}

