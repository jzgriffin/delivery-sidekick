import 'package:geolocator/geolocator.dart';
import 'package:money/money.dart';

class SpaceTimeStamp {
  double latitude;
  double longitude;
  DateTime time;
  double altitude;
  double accuracy;
  double heading;
  double speed;
  double speedAccuracy;

  SpaceTimeStamp(
      {this.latitude,
      this.longitude,
      this.time,
      this.altitude,
      this.accuracy,
      this.heading,
      this.speed,
      this.speedAccuracy});

  factory SpaceTimeStamp.fromPosition(Position position) => SpaceTimeStamp(
        latitude: position.latitude,
        longitude: position.longitude,
        time: position.timestamp,
        altitude: position.altitude,
        accuracy: position.accuracy,
        heading: position.heading,
        speed: position.speed,
        speedAccuracy: position.speedAccuracy,
      );

  factory SpaceTimeStamp.fromMap(Map<String, dynamic> map) => SpaceTimeStamp(
        latitude: map['latitude'],
        longitude: map['longitude'],
        time: map['time'],
        altitude: map['altitude'],
        accuracy: map['accuracy'],
        heading: map['heading'],
        speed: map['speed'],
        speedAccuracy: map['speedAccuracy'],
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'time': time,
        'altitude': altitude,
        'accuracy': accuracy,
        'heading': heading,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
      };

  static List<SpaceTimeStamp> fromMaps(List<Map<String, dynamic>> maps) =>
      maps.map((x) => SpaceTimeStamp.fromMap(x)).toList();
  static List<Map<String, dynamic>> toMaps(List<SpaceTimeStamp> stamps) =>
      stamps.map((x) => x.toMap()).toList();
}

Map<String, dynamic> moneyToMap(Money money) => {
      'amount': money.amount,
      'symbol': money.currency.code,
    };

Money moneyFromMap(Map<String, dynamic> map) =>
    Money(map['amount'], map['symbol']);

enum PaymentMethod { card, cash }

const paymentMethods = <String, PaymentMethod>{
  'card': PaymentMethod.card,
  'cash': PaymentMethod.cash,
};

String paymentMethodToString(PaymentMethod unit) => paymentMethods.entries
    .where((e) => e.value == unit)
    .map((e) => e.key)
    .single;
PaymentMethod paymentMethodFromString(String string) => paymentMethods.entries
    .where((e) => e.key == string)
    .map((e) => e.value)
    .single;

class Payment {
  PaymentMethod method;
  Money money;

  Payment({this.method, this.money});

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
        method: paymentMethodFromString(map['method']),
        money: moneyFromMap(map['money']),
      );

  Map<String, dynamic> toMap() => {
        'method': paymentMethodToString(method),
        'money': moneyToMap(money),
      };

  static List<Payment> fromMaps(List<Map<String, dynamic>> maps) =>
      maps.map((x) => Payment.fromMap(x)).toList();
  static List<Map<String, dynamic>> toMaps(List<Payment> payments) =>
      payments.map((x) => x.toMap()).toList();
}

enum MileageUnit { run, delivery, mile, kilometer }

const mileageUnits = <String, MileageUnit>{
  'run': MileageUnit.run,
  'delivery': MileageUnit.delivery,
  'mile': MileageUnit.mile,
  'kilometer': MileageUnit.kilometer,
};

String mileageUnitToString(MileageUnit unit) =>
    mileageUnits.entries.where((e) => e.value == unit).map((e) => e.key).single;
MileageUnit mileageUnitFromString(String string) => mileageUnits.entries
    .where((e) => e.key == string)
    .map((e) => e.value)
    .single;

class Mileage {
  Money rate;
  num divisor;
  MileageUnit unit;

  Mileage({this.rate, this.divisor, this.unit});

  factory Mileage.fromMap(Map<String, dynamic> map) => Mileage(
        rate: moneyFromMap(map['rate']),
        divisor: map['divisor'],
        unit: mileageUnitFromString(map['unit']),
      );

  Map<String, dynamic> toMap() => {
        'rate': moneyToMap(rate),
        'divisor': divisor,
        'unit': mileageUnitToString(unit),
      };
}

class Job {
  String name;
  String address;
  String phone;
  Money bank;
  Mileage mileage;

  Job({this.name, this.address, this.phone, this.bank, this.mileage});

  factory Job.fromMap(Map<String, dynamic> map) => Job(
        name: map['name'],
        address: map['address'],
        phone: map['phone'],
        bank: moneyFromMap(map['bank']),
        mileage: Mileage.fromMap(map['mileage']),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'phone': phone,
        'bank': bank == null ? null : moneyToMap(bank),
        'mileage': mileage?.toMap(),
      };
}

class Shift {
  DateTime startStamp;
  DateTime endStamp;

  Shift({this.startStamp, this.endStamp});

  factory Shift.fromMap(Map<String, dynamic> map) => Shift(
        startStamp: map['startStamp'],
        endStamp: map['endStamp'],
      );

  Map<String, dynamic> toMap() => {
        'startStamp': startStamp,
        'endStamp': endStamp,
      };
}

class Delivery {
  String address;
  List<Payment> price;
  List<Payment> tender;
  SpaceTimeStamp leaveStamp;
  SpaceTimeStamp arriveStamp;
  SpaceTimeStamp departStamp;
  SpaceTimeStamp returnStamp;
  List<SpaceTimeStamp> routeStamps;

  Delivery(
      {this.address,
      this.price,
      this.tender,
      this.leaveStamp,
      this.arriveStamp,
      this.departStamp,
      this.returnStamp,
      this.routeStamps});

  factory Delivery.fromMap(Map<String, dynamic> map) => Delivery(
        address: map['address'],
        price: Payment.fromMaps(map['price']),
        tender: map['tender'] == null ? null : Payment.fromMaps(map['tender']),
        leaveStamp: map['leaveStamp'] == null
            ? null
            : SpaceTimeStamp.fromMap(map['leaveStamp']),
        arriveStamp: map['arriveStamp'] == null
            ? null
            : SpaceTimeStamp.fromMap(map['arriveStamp']),
        departStamp: map['departStamp'] == null
            ? null
            : SpaceTimeStamp.fromMap(map['departStamp']),
        returnStamp: map['returnStamp'] == null
            ? null
            : SpaceTimeStamp.fromMap(map['returnStamp']),
        routeStamps: map['routeStamps'] == null
            ? null
            : SpaceTimeStamp.fromMaps(map['routeStamps']),
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'price': Payment.toMaps(price),
        'tender': tender == null ? null : Payment.toMaps(tender),
        'leaveStamp': leaveStamp?.toMap(),
        'departStamp': departStamp?.toMap(),
        'returnStamp': returnStamp?.toMap(),
        'routeStamps':
            routeStamps == null ? null : SpaceTimeStamp.toMaps(routeStamps),
      };
}
