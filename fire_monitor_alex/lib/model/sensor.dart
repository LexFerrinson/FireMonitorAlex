import 'env_data.dart';

class Sensor {
  String longitude;
  String latitude;
  String name;
  List<EnvData>? dataRecord;

  Sensor(this.longitude, this.latitude, this.name, this.dataRecord);

  Sensor.fromJson(Map<String, dynamic> json)
      : longitude = json['longitude'],
        latitude = json['latitude'],
        name = json['name'],
        dataRecord = List<EnvData>.from((json['data_record'] ??= []).map(
            (x) => EnvData.fromJson(Map<String, dynamic>.from(x as dynamic))));

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'name': name,
        'data_record': dataRecord,
      };
}
