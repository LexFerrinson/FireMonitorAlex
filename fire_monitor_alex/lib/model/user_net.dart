import 'dart:convert';

import 'package:fire_monitor_alex/model/remote_node.dart';

class UserNet {
  Map<String, RemoteNode> nodes;
  int counter_nodes;

  UserNet(this.nodes, this.counter_nodes);

  UserNet.fromJson(Map<String, dynamic> json)
      : nodes = Map<String, RemoteNode>.from(
            (json['nodes'] as Map<dynamic, dynamic>).map((keyes, value) {
          Map<String, RemoteNode> map = {
            keyes:
                RemoteNode.fromJson(Map<String, dynamic>.from(value as dynamic))
          };
          return MapEntry(keyes,
              RemoteNode.fromJson(Map<String, dynamic>.from(value as dynamic)));
        })),
        counter_nodes = json['counter_nodes'];

  /*UserNet.fromJson(dynamic json)
      : nodes = List<RemoteNode>.from(
            json['nodes'].map((x) => RemoteNode.fromJson(x as dynamic))),
        counter_nodes = json['counter_nodes'];*/

  Map<String, dynamic> toJson() => {
        'nodes': nodes,
        'counter_nodes': counter_nodes,
      };
}


//https://stackoverflow.com/a/68067087/18501762 deserialize json

//https://randomnerdtutorials.com/esp32-lora-rfm95-transceiver-arduino-ide/ lora with esp32
//https://www.youtube.com/watch?v=w6ygDCTSQug&ab_channel=RuiSantos esp32 with lora i mapa de gateways communitaries


//Papers

//https://www.nature.com/articles/s41598-020-67530-4 Observational evidence of wildfire-promoting soil moisture anomalies
