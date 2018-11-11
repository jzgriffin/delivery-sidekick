import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

/// Widget for displaying the dashboard overview
/// This class is stateful because contains multiple tabs
class DashboardPage extends StatefulWidget {
  /// The current signed-in user
  final FirebaseUser user;

  /// Constructs this widget instance
  DashboardPage({@required this.user});

  /// Creates the mutable state for this widget
  @override
  createState() => _DashboardPageState();
}

/// State for the dashboard page
class _DashboardPageState extends State<DashboardPage> {
  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(), // TODO
        appBar: AppBar(
          centerTitle: true,
          title: Text('Dashboard'),
        ),
        drawer: UserDrawer(user: widget.user),
      );
}
