import 'package:cloud_firestore/cloud_firestore.dart';

import 'job.dart';

class User {
  DocumentReference reference;

  User({this.reference});

  factory User.fromMap(Map map, {DocumentReference reference}) => User(
        reference: reference,
      );

  factory User.fromSnapshot(DocumentSnapshot snapshot) =>
      User.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {};

  Stream<List<Job>> jobSnapshots() =>
      reference.collection('jobs').snapshots().map((query) => query.documents
          .map((document) => Job.fromSnapshot(document))
          .toList());
}
