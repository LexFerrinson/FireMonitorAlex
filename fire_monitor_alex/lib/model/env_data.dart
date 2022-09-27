class EnvData {
  String temperature;
  String humidity;
  String timestamp;

  EnvData(this.temperature, this.humidity, this.timestamp);

  EnvData.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'],
        humidity = json['humidity'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'humidity': humidity,
        'timestamp': timestamp,
      };
}
