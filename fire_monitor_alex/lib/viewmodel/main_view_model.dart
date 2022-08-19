import 'package:fire_monitor_alex/model/firebase.dart';
import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:flutter/widgets.dart';

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
