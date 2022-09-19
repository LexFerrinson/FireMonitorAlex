import 'package:fire_monitor_alex/view/map.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';
import 'package:flutter/material.dart';
import 'new_node_view.dart';
import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextEditingController longitudController = TextEditingController();
TextEditingController latitudeController = TextEditingController();
TextEditingController nameController = TextEditingController();

class PageFirst extends StatefulWidget {
  const PageFirst({Key? key}) : super(key: key);

  @override
  State<PageFirst> createState() => _PageFirstState();
}

class _PageFirstState extends State<PageFirst> {
  bool enterNewNode = false;

  void showToastNotification(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(200, 65, 64, 64),
        fontSize: 18.0);
  }

  void _showDialog() {
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
            constraints: const BoxConstraints.expand(width: 200, height: 200),
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
                      'No data',
                      'No data');
                  addNode(node, context, () {
                    showToastNotification('Node Added Correctly');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: enterNewNode ? NewNodeView() : MapView(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            onPressed: _showDialog,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
