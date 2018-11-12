import 'package:location/location.dart';

class SpaceStamp {
  double latitude;
  double longitude;
  double altitude;
  double accuracy;
  double speed;
  double speedAccuracy;

  SpaceStamp(
      {this.latitude,
      this.longitude,
      this.altitude,
      this.accuracy,
      this.speed,
      this.speedAccuracy});

  factory SpaceStamp.fromMap(Map map) => SpaceStamp(
        latitude: map['latitude'],
        longitude: map['longitude'],
        altitude: map['altitude'],
        accuracy: map['accuracy'],
        speed: map['speed'],
        speedAccuracy: map['speed_accuracy'],
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'accuracy': accuracy,
        'speed': speed,
        'speed_accuracy': speedAccuracy,
      };

  static Future<SpaceStamp> here() async =>
      Location().getLocation().then((x) => SpaceStamp.fromMap(x));
  static Stream<SpaceStamp> hereStream() =>
      Location().onLocationChanged().map((x) => SpaceStamp.fromMap(x));
}
