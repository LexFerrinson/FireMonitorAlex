import 'dart:async';

import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../model/user_net.dart';
import 'widgets/combo_box.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';

class PageSecond extends StatefulWidget {
  const PageSecond({Key? key}) : super(key: key);

  @override
  State<PageSecond> createState() => _PageSecondState();
}

class _PageSecondState extends State<PageSecond> {
  UserNet? userNet;
  String? firstItem;

  @override
  void initState() {
    //getFirstNode();
    super.initState();
  }

  void getFirstNode() async {
    var usernet = await readNetwork();
    if (usernet != null) {
      //firstItem = usernet.nodes[0].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        /*alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          StreamBuilder<DatabaseEvent>(
            stream: getNodesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var vl = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as dynamic);
                userNet = UserNet.fromJson(vl);
                return NodeCB(
                  startItem: firstItem,
                  nodeItems: userNet != null
                      ? [] //userNet!.nodes.map((e) => e.name).toList()
                      : [],
                  selCallback: selectedNode,
                );
              } else {
                return NodeCB(
                  startItem: firstItem,
                  nodeItems: [],
                  selCallback: selectedNode,
                );
              }
            },
          ),
        ],
      ),*/
        );
  }

  void selectedNode(String name) {
    if (userNet != null) {
      /*for (RemoteNode rn in userNet!.nodes) {
        if (rn.name == name) {
          print('Selected node $name');
        }
      }*/
    }
  }
}
