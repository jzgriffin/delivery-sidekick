import 'package:delivery_sidekick/page/dashboard_page.dart';
import 'package:delivery_sidekick/page/signin_page.dart';
import 'package:delivery_sidekick/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Widget for displaying the details of an individual currency
class SplashPage extends StatefulWidget {
  /// Creates the mutable state for this widget
  @override
  createState() => _SplashPageState();
}

/// State for the splash page
class _SplashPageState extends State<SplashPage> {
  /// Instance of the Firebase authentication library
  final _auth = FirebaseAuth.instance;

  /// Called when this object is inserted into the tree
  @override
  void initState() {
    super.initState();

    // FIXME: Loading is a little flickery
    // Perhaps add a brief delay to ensure that animations have time to run
    _auth.currentUser().then((user) {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignInPage()));
      } else {
        Session.signIn(user: user);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DashboardPage()));
      }
    });
  }

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) =>
      // TODO: Use a splash image
      Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
