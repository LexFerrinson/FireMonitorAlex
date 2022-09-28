import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/main_view_model.dart';

class SensorCard extends StatefulWidget {
  const SensorCard(
      {Key? key, required this.rnHardwareNum, required this.sensorHardwareNum})
      : super(key: key);

  final String rnHardwareNum;
  final String sensorHardwareNum;

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  @override
  Widget build(BuildContext context) {
    //Every sensor has its own streambuilder to receive new data as it comes and
    //display it on the line chart.
    return StreamBuilder<DatabaseEvent>(
      stream:
          getStreamFromSensor(widget.rnHardwareNum, widget.sensorHardwareNum),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.snapshot.exists) {}
        return const Text('Holaaaaa');
      },
    );
  }
}
