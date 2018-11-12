import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_sidekick/card/run_card.dart';
import 'package:delivery_sidekick/model/run.dart';
import 'package:delivery_sidekick/model/shift.dart';
import 'package:delivery_sidekick/page/run_page.dart';
import 'package:delivery_sidekick/widget/drawer.dart';
import 'package:flutter/material.dart';

/// Widget for displaying an individual shift
class ShiftPage extends StatelessWidget {
  /// Instance of the Firestore library
  final _firestore = Firestore.instance;

  /// Shift to display
  final Shift shift;

  /// Constructs a class instance
  ShiftPage({@required this.shift});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: shift.runSnapshots(),
            builder: (context, AsyncSnapshot<List<Run>> snapshot) {
              if (snapshot.hasError) {
                // TODO: Error reporting
                print('${snapshot.error}');
                return Center(
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 64.0,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              snapshot.data
                  .sort((x1, x2) => x2.startStamp.compareTo(x1.startStamp));
              return ListView(
                children:
                    snapshot.data.map((run) => RunCard(run: run)).toList(),
              );
            }),
        floatingActionButton: _buildFloatingActionButton(context),
        appBar: AppBar(
          title: Text('Shift'),
          actions: _buildActions(context),
        ),
        drawer: UserDrawer(),
      );

  /// Builds the floating action button for the scaffold
  Widget _buildFloatingActionButton(BuildContext context) {
    if (shift.endStamp != null) {
      return null;
    }
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => _startRun(context),
    );
  }

  /// Builds the list of action widgets for the app bar
  List<Widget> _buildActions(BuildContext context) {
    var actions = <Widget>[];

    if (shift.endStamp == null) {
      actions.add(IconButton(
        icon: const Icon(Icons.stop),
        onPressed: () => _stop(context),
      ));
    }

    actions.add(IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => _attemptDelete(context),
    ));

    return actions;
  }

  /// Stops the current shift, setting its end time to the current time
  void _stop(BuildContext context) async {
    _firestore.runTransaction((tx) async {
      await tx.update(
          shift.reference, <String, dynamic>{'endStamp': DateTime.now()});
    });
    Navigator.pop(context);
  }

  /// Prompts the user to confirm shift deletion
  void _attemptDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Delete shift?'),
            content: Text(
                'This will delete the selected shift and all of its data.'),
            actions: [
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _delete(context);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  /// Deletes the shift from the database
  void _delete(BuildContext context) async {
    _firestore.runTransaction((tx) async {
      await tx.delete(shift.reference);
    });
    Navigator.pop(context);
  }

  /// Starts a new run
  void _startRun(BuildContext context) async {
    var run = Run(startStamp: DateTime.now());
    run.reference = await shift.reference.collection('runs').add(run.toMap());
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RunPage(run: run)));
  }
}
