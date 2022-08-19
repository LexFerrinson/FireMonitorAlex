class RemoteNode {
  double longitude;
  double latitude;
  String name;
  String humidity;
  String temperature;

  RemoteNode(this.longitude, this.latitude, this.name, this.humidity,
      this.temperature);

  RemoteNode.fromJson(Map<String, dynamic> json)
      : longitude = json['longitude'],
        latitude = json['latitude'],
        name = json['name'],
        humidity = json['humidity'],
        temperature = json['temperature'];

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'name': name,
        'humidity': humidity,
        'temperature': temperature,
      };
}
