import 'package:fire_monitor_alex/model/env_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../model/sensor.dart';
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
            snapshot.data!.snapshot.exists) {
          //Read the data record of the sensor to print the data in the graph
          //We get the whole sensor to check if some parameter such as name has changed
          Sensor s = Sensor.fromJson(Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as dynamic));

          //Aixo seria si nomes volguessim el data record
          //List<EnvData> data_record = List<EnvData>.from(
          //    (snapshot.data!.snapshot.value as dynamic).map((x) =>
          //        EnvData.fromJson(Map<String, dynamic>.from(x as dynamic))));
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 300,
                width: 300,
                child: Column(
                  children: [
                    Text(s.name),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
