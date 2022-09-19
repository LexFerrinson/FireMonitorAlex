import 'package:fire_monitor_alex/model/firebase.dart';
import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:fire_monitor_alex/model/user_net.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

typedef CustomCallback = void Function(UserNet);

Future signIn(String email, String password, BuildContext context,
    VoidCallback onSuccess) async {
  await FirebaseSignIn(email, password);
  onSuccess.call();
}

Future addNode(
    RemoteNode node, BuildContext context, VoidCallback onSuccess) async {
  await FirebaseAddNode(node);
  onSuccess.call();
}

Future<UserNet?> readNetwork() async {
  return await FirebaseGetNetwork();
}

void subscribeToBBDDchange(CustomCallback onSuccess) {
  FirebaseListenBBDDchange(onSuccess);
}
