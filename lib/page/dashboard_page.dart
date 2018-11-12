import 'package:delivery_sidekick/widget/drawer.dart';
import 'package:flutter/material.dart';

/// Widget for displaying the dashboard overview
class DashboardPage extends StatefulWidget {
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
          title: Text('Dashboard'),
        ),
        drawer: UserDrawer(),
      );
}
