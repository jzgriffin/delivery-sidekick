import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/money.dart';

import 'mileage.dart';
import 'money.dart';
import 'shift.dart';

class Job {
  DocumentReference reference;

  String name;
  String address;
  String phone;
  Money bank;
  Mileage mileage;

  Job(
      {this.reference,
      this.name,
      this.address,
      this.phone,
      this.bank,
      this.mileage});

  factory Job.fromMap(Map map, {DocumentReference reference}) => Job(
        reference: reference,
        name: map['name'],
        address: map['address'],
        phone: map['phone'],
        bank: moneyFromMap(map['bank']),
        mileage: Mileage.fromMap(map['mileage']),
      );

  factory Job.fromSnapshot(DocumentSnapshot snapshot) =>
      Job.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'phone': phone,
        'bank': moneyToMap(bank),
        'mileage': mileage?.toMap(),
      };

  Stream<Job> snapshots() =>
      reference.snapshots().map((snapshot) => Job.fromSnapshot(snapshot));

  Stream<List<Shift>> shiftSnapshots() =>
      reference.collection('shifts').snapshots().map((query) =>
          query.documents.map((document) => Shift.fromSnapshot(document)).toList());
}
