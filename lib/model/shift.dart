import 'package:cloud_firestore/cloud_firestore.dart';

import 'run.dart';

class Shift {
  DocumentReference reference;

  DateTime startStamp;
  DateTime endStamp;

  Shift({this.reference, this.startStamp, this.endStamp});

  factory Shift.fromMap(Map map, {DocumentReference reference}) => Shift(
        reference: reference,
        startStamp: map['startStamp'],
        endStamp: map['endStamp'],
      );

  factory Shift.fromSnapshot(DocumentSnapshot snapshot) =>
      Shift.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'startStamp': startStamp,
        'endStamp': endStamp,
      };

  Stream<Shift> snapshots() =>
      reference.snapshots().map((snapshot) => Shift.fromSnapshot(snapshot));

  Stream<List<Run>> runSnapshots() =>
      reference.collection('runs').snapshots().map((query) => query.documents
          .map((document) => Run.fromSnapshot(document))
          .toList());
}
