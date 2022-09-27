import 'package:fire_monitor_alex/model/sensor.dart';

class RemoteNode {
  String longitude;
  String latitude;
  String name;
  Map<String, Sensor>? sensors;

  RemoteNode(this.longitude, this.latitude, this.name, this.sensors);

  RemoteNode.fromJson(Map<String, dynamic> json)
      : longitude = json['longitude'],
        latitude = json['latitude'],
        name = json['name'],
        sensors = Map<String, Sensor>.from(
            (json['sensors'] ??= {}).map((keyes, value) {
          return MapEntry(keyes,
              Sensor.fromJson(Map<String, dynamic>.from(value as dynamic)));
        }));

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'name': name,
        'sensors': sensors,
      };
}
