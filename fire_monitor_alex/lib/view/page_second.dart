import 'dart:async';

import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:fire_monitor_alex/model/sensor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../model/user_net.dart';
import 'widgets/combo_box.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';
import 'widgets/sensor_data_card.dart';

class PageSecond extends StatefulWidget {
  const PageSecond({Key? key}) : super(key: key);

  @override
  State<PageSecond> createState() => _PageSecondState();
}

class _PageSecondState extends State<PageSecond> {
  UserNet? userNet;
  String? firstItem;
  String? selectedNode;

  @override
  void initState() {
    getFirstNode();
    super.initState();
  }

  void getFirstNode() async {
    UserNet? usernet = await readNetwork();
    if (usernet != null) {
      selectedNode = usernet.nodes.keys.first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          //This streambuilder is responsible for displaying all the remote nodes in a combo box
          StreamBuilder<DatabaseEvent>(
            stream: getNodesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.snapshot.exists) {
                var vl = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as dynamic);
                UserNet? userNet = UserNet.fromJson(vl);
                return NodeCB(
                  startItem: '',
                  nodeItems: userNet.nodes.keys.toList(),
                  selCallback: selectedNodeChange,
                );
              } else {
                return NodeCB(
                  startItem: '',
                  nodeItems: [],
                  selCallback: selectedNodeChange,
                );
              }
            },
          ),
          //This streambuilder is respoonsible for displaying the sensor data cards
          StreamBuilder<DatabaseEvent>(
            stream: getNodesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.snapshot.exists) {
                var vl = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as dynamic);
                UserNet? userNet = UserNet.fromJson(vl);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: createSensorDataCards(userNet),
                );
              } else {
                return Column();
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> createSensorDataCards(UserNet? userNet) {
    List<Widget> cardList = [];
    if (userNet != null &&
        selectedNode != null &&
        userNet.nodes[selectedNode] != null &&
        userNet.nodes[selectedNode]!.sensors != null) {
      userNet.nodes[selectedNode]!.sensors!.forEach((key, value) {
        cardList.add(
            SensorCard(rnHardwareNum: selectedNode!, sensorHardwareNum: key));
      });
    }
    return cardList;
  }

  void selectedNodeChange(String name) {
    setState(() {
      selectedNode = name;
    });
  }
}
