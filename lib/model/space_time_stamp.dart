import 'space_stamp.dart';

class SpaceTimeStamp {
  DateTime time;
  SpaceStamp space;

  SpaceTimeStamp({this.time, this.space});

  factory SpaceTimeStamp.fromMap(Map map) => map == null
      ? null
      : SpaceTimeStamp(
          time: map['time'],
          space: SpaceStamp.fromMap(map['space']),
        );

  Map<String, dynamic> toMap() => {
        'time': time,
        'space': space.toMap(),
      };

  static List<SpaceTimeStamp> fromMaps(List<Map> maps) =>
      maps.map((x) => SpaceTimeStamp.fromMap(x)).toList();
  static List<Map<String, dynamic>> toMaps(List<SpaceTimeStamp> stamps) =>
      stamps.map((x) => x.toMap()).toList();

  static Future<SpaceTimeStamp> hereNow() async => SpaceStamp.here()
      .then((x) => SpaceTimeStamp(time: DateTime.now(), space: x));
  static Stream<SpaceTimeStamp> hereNowStream() => SpaceStamp.hereStream()
      .map((x) => SpaceTimeStamp(time: DateTime.now(), space: x));
}
