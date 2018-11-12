import 'package:cloud_firestore/cloud_firestore.dart';

import 'delivery.dart';

class Run {
  DocumentReference reference;

  DateTime startStamp;
  DateTime endStamp;

  Run({this.reference, this.startStamp, this.endStamp});

  factory Run.fromMap(Map map, {DocumentReference reference}) => Run(
        reference: reference,
        startStamp: map['startStamp'],
        endStamp: map['endStamp'],
      );

  factory Run.fromSnapshot(DocumentSnapshot snapshot) =>
      Run.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'startStamp': startStamp,
        'endStamp': endStamp,
      };

  Stream<Run> snapshots() =>
      reference.snapshots().map((snapshot) => Run.fromSnapshot(snapshot));

  Stream<List<Delivery>> deliverySnapshots() => reference
      .collection('deliveries')
      .snapshots()
      .map((query) => query.documents
          .map((document) => Delivery.fromSnapshot(document))
          .toList());
}
