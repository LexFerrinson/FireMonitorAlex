import 'dart:async';

import 'package:fire_monitor_alex/model/user_net.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'remote_node.dart';
import 'dart:convert';

typedef CustomCallback = void Function(UserNet);

const int EMPTY = -1;
const String COUNTER_NDOES = "counter_nodes";

Future FirebaseSignIn(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future FirebaseAddNode(RemoteNode node) async {
  final FirebaseApp myApp = Firebase.app();
  final database = FirebaseDatabase.instanceFor(
          app: myApp,
          databaseURL:
              "https://firemonitoralex-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  //String cleanEmail = CleanEmail(email);
  String? uid = FirebaseGetUid();
  if (uid != null) {
    int id = await FirebaseCheckNextId(uid, database);
    if (id != EMPTY) {
      //The first time a user adds a new node, it has to be
      //defined a new counter for node id
      DatabaseReference ref = database.child('$uid/nodes/$id');
      await ref.set(node.toJson());
      ref = database.child('$uid/$COUNTER_NDOES');
      await ref.set(++id);
    } else {
      DatabaseReference ref = database.child('$uid/$COUNTER_NDOES');
      await ref.set(0);
      await FirebaseAddNode(node);
    }
  }
}

Future<int> FirebaseCheckNextId(String id, DatabaseReference ref) async {
  int counter = EMPTY;
  final snapshot = await ref.child('$id/$COUNTER_NDOES').get();
  if (snapshot.exists) {
    counter = snapshot.value as int;
  }
  return counter;
}

String? FirebaseGetUid() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
  return null;
}

String CleanEmail(String email) {
  //The email is used as a user identifier, but some characters
  //have to be replaces because are not supported by firebase.
  String e1 = email.split('.').join(',');
  String e2 = e1.split('#').join(',');
  String e3 = e2.split('\$').join(',');
  String e4 = e3.split('[').join(',');
  String e5 = e4.split(']').join(',');
  return e5;
}

Future<UserNet?> FirebaseGetNetwork() async {
  final FirebaseApp myApp = Firebase.app();
  final database = FirebaseDatabase.instanceFor(
          app: myApp,
          databaseURL:
              "https://firemonitoralex-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();

  String? uid = FirebaseGetUid();
  if (uid != null) {
    try {
      final DataSnapshot snapshot = await database.child(uid).get();
      //UserNet v1 = UserNet.fromJson(snapshot.value as dynamic);
      var vl = Map<String, dynamic>.from(snapshot.value as dynamic);
      return UserNet.fromJson(vl);
    } on Exception catch (_) {
      return null;
    }
  }
  return null;
}

void FirebaseListenBBDDchange(CustomCallback onSuccess) {
  final FirebaseApp myApp = Firebase.app();
  final database = FirebaseDatabase.instanceFor(
          app: myApp,
          databaseURL:
              "https://firemonitoralex-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  String? uid = FirebaseGetUid();
  if (uid != null) {
    database.child(uid).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      var vl = Map<String, dynamic>.from(snapshot.value as dynamic);
      onSuccess(UserNet.fromJson(vl));
    });
  }
}
