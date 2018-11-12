import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_sidekick/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Application-wide session information
class Session {
  /// Internal instance of the session
  static Session _instance;

  /// Returns the internal instance
  factory Session() => _instance;

  /// Currently authenticated user
  final FirebaseUser authUser;

  /// Reference to the user in the database
  final User user;

  /// Constructs a class instance
  Session._({@required this.authUser})
      : user = User(
            reference: Firestore.instance.document('users/${authUser.uid}'));

  /// Makes the given user the signed-in user
  static void signIn({@required user}) => _instance = Session._(authUser: user);

  /// Resets the session to a null instance
  static Session signOut() => _instance = null;
}
