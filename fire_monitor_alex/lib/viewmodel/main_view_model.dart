import 'package:fire_monitor_alex/model/firebase.dart';
import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:fire_monitor_alex/model/user_net.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/sensor.dart';

typedef CustomCallback = void Function(UserNet);

Future signIn(String email, String password, BuildContext context,
    VoidCallback onSuccess) async {
  await FirebaseSignIn(email, password);
  onSuccess.call();
}

Future addNode(RemoteNode node, String hardwareNumber, BuildContext context,
    VoidCallback onSuccess) async {
  await FirebaseAddNode(node, hardwareNumber);
  onSuccess.call();
}

Future addSensor(
    Sensor sensor,
    String hardwareRN,
    String hardwareNumber,
    BuildContext context,
    VoidCallback onSuccess,
    VoidCallback onFailure) async {
  bool ok = await FirebaseAddSensor(sensor, hardwareRN, hardwareNumber);
  if (ok) {
    onSuccess.call();
  } else {
    onFailure.call();
  }
}

Future<UserNet?> readNetwork() async {
  return await FirebaseGetNetwork();
}

void subscribeToBBDDchange(CustomCallback onSuccess) {
  FirebaseListenBBDDchange(onSuccess);
}

Stream<DatabaseEvent>? getNodesStream() {
  return FirebaseRealTimeUserNet();
}

Stream<DatabaseEvent>? getStreamFromSensor(String rnNum, String sensorNum) {
  return FirebaseGetRealTimeSensor(rnNum, sensorNum);
}
