import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/money.dart';

import 'payment.dart';
import 'space_time_stamp.dart';

class Delivery {
  DocumentReference reference;

  String address;
  List<Payment> price;
  List<Payment> tender;
  SpaceTimeStamp leaveStamp;
  SpaceTimeStamp arriveStamp;
  SpaceTimeStamp departStamp;
  SpaceTimeStamp returnStamp;
  List<SpaceTimeStamp> routeStamps;

  Delivery(
      {this.reference,
      this.address,
      this.price,
      this.tender,
      this.leaveStamp,
      this.arriveStamp,
      this.departStamp,
      this.returnStamp,
      this.routeStamps});

  factory Delivery.fromMap(Map map, {DocumentReference reference}) => Delivery(
        reference: reference,
        address: map['address'],
        price: Payment.fromMaps(map['price']),
        tender: map['tender'] == null ? null : Payment.fromMaps(map['tender']),
        leaveStamp: SpaceTimeStamp.fromMap(map['leaveStamp']),
        arriveStamp: SpaceTimeStamp.fromMap(map['arriveStamp']),
        departStamp: SpaceTimeStamp.fromMap(map['departStamp']),
        returnStamp: SpaceTimeStamp.fromMap(map['returnStamp']),
        routeStamps: map['routeStamps'] == null
            ? null
            : SpaceTimeStamp.fromMaps(map['routeStamps']),
      );

  factory Delivery.fromSnapshot(DocumentSnapshot snapshot) =>
      Delivery.fromMap(snapshot.data, reference: snapshot.reference);

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

  Stream<Delivery> snapshots() =>
      reference.snapshots().map((snapshot) => Delivery.fromSnapshot(snapshot));

  Money totalPrice() => Payment.sum(price);
  Money totalTender() => Payment.sum(tender);
}
