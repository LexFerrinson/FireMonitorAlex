import 'package:fire_monitor_alex/model/sensor.dart';
import 'package:fire_monitor_alex/view/map.dart';
import 'package:fire_monitor_alex/view/widgets/combo_box.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'new_node_view.dart';
import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fire_monitor_alex/model/user_net.dart';

TextEditingController longitudController = TextEditingController();
TextEditingController latitudeController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController hardwareController = TextEditingController();

class PageFirst extends StatefulWidget {
  const PageFirst({Key? key}) : super(key: key);

  @override
  State<PageFirst> createState() => _PageFirstState();
}

class _PageFirstState extends State<PageFirst> {
  bool enterNewNode = false;
  String topData = 'Please select a node';
  Color floatingInfoColor = const Color.fromARGB(251, 37, 37, 37);
  bool showFloatInfo = false;
  String? selectedRN;

  void updateFloatingInfo(String h, String t, Color c) {
    showFloatInfo = true;
    setState(() {
      topData = 'RH: $h (%), T: $t (deg)';
      floatingInfoColor = c;
    });
  }

  void hideFloatingInfo() {
    showFloatInfo = false;
    selectedRN = null;
    setState(() {});
  }

  @override
  void initState() {
    showFloatInfo = false;
    // TODO: implement initState
    super.initState();
  }

  void showToastNotification(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(200, 65, 64, 64),
        fontSize: 18.0);
  }

  void selCallback(String name) {
    selectedRN = name;
  }

  void showDialogSensor() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Add new sensor"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(20.0),
          content: Container(
            constraints: const BoxConstraints.expand(width: 200, height: 300),
            child: Column(
              children: [
                StreamBuilder<DatabaseEvent>(
                  stream: getNodesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.snapshot.exists) {
                      var vl = Map<String, dynamic>.from(
                          snapshot.data!.snapshot.value as dynamic);
                      UserNet? userNet = UserNet.fromJson(vl);
                      selectedRN = userNet.nodes.keys.first;
                      return NodeCB(
                          startItem: '',
                          nodeItems: userNet.nodes.keys.toList(),
                          selCallback: selCallback);
                    } else {
                      return NodeCB(
                          startItem: '',
                          nodeItems: [],
                          selCallback: selCallback);
                    }
                  },
                ),
                TextField(
                  controller: longitudController,
                  decoration: const InputDecoration(
                    hintText: 'Input longitude',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter latitude',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Node name',
                  ),
                ),
                TextField(
                  controller: hardwareController,
                  decoration: const InputDecoration(
                    hintText: 'Hardware num',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                try {
                  Sensor sensor = Sensor(longitudController.text,
                      latitudeController.text, nameController.text, []);
                  addSensor(sensor, selectedRN ??= '', hardwareController.text,
                      context, () {
                    showToastNotification('Node Added Correctly');
                    //TODO: s'ha d'afegir un nou marcador
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }, () {
                    showToastNotification('Node Not Added');
                    //TODO: s'ha d'afegir un nou marcador
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  });
                } on Exception catch (_) {
                  showToastNotification('Invalid parameters');
                }
              },
            ),

            ElevatedButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogRemoteNode() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Add new monitor node"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(20.0),
          content: Container(
            constraints: const BoxConstraints.expand(width: 200, height: 250),
            child: Column(
              children: [
                TextField(
                  controller: longitudController,
                  decoration: const InputDecoration(
                    hintText: 'Input longitude',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter latitude',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Node name',
                  ),
                ),
                TextField(
                  controller: hardwareController,
                  decoration: const InputDecoration(
                    hintText: 'Hardware num',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                try {
                  RemoteNode node = RemoteNode(
                    longitudController.text,
                    latitudeController.text,
                    nameController.text,
                    {},
                  );
                  addNode(
                    node,
                    hardwareController.text,
                    context,
                    () {
                      showToastNotification('Node Added Correctly');
                      //TODO: s'ha d'afegir un nou marcador
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  );
                } on Exception catch (_) {
                  showToastNotification('Invalid parameters');
                }
              },
            ),

            ElevatedButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          MapView(
            floatingInfo: updateFloatingInfo,
            hideFloatingInfo: hideFloatingInfo,
          ),
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: width,
                color: Colors.transparent,
                child: showFloatInfo
                    ? Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: floatingInfoColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          topData,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(225, 230, 230, 230),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              onPressed: showDialogRemoteNode,
              tooltip: 'Add RemoteNode',
              heroTag: null,
              child: const Icon(Icons.device_hub),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              onPressed: showDialogSensor,
              tooltip: 'Add sensor',
              heroTag: null,
              child: const Icon(Icons.sensors_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
