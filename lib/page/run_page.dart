import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_sidekick/card/delivery_card.dart';
import 'package:delivery_sidekick/model/delivery.dart';
import 'package:delivery_sidekick/model/run.dart';
import 'package:delivery_sidekick/model/space_time_stamp.dart';
import 'package:delivery_sidekick/page/edit_delivery_page.dart';
import 'package:delivery_sidekick/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum Status { planning, inProgress, complete }

/// Widget for displaying an individual run
class RunPage extends StatelessWidget {
  /// Instance of the Firestore library
  final _firestore = Firestore.instance;

  /// Run to display
  final Run run;

  /// Constructs a class instance
  RunPage({@required this.run});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: run.deliverySnapshots(),
        builder: (context, AsyncSnapshot<List<Delivery>> snapshot) {
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

          var status = !snapshot.data.any((x) => x.leaveStamp != null)
              ? Status.planning
              : !snapshot.data.any((x) => x.returnStamp != null)
                  ? Status.inProgress
                  : Status.complete;

          var children = snapshot.data
              .map((delivery) => DeliveryCard(delivery: delivery))
              .cast<Widget>()
              .toList();
          if (status == Status.planning) {
            children.add(_buildAppendButton(context));
          }
          
          final mapController =
              GoogleMapOverlayController.fromSize(width: 300.0, height: 200.0);
          children.add(GoogleMapOverlay(controller: mapController));

          return Scaffold(
            body: ListView(
              children: children,
            ),
            floatingActionButton: _buildFloatingActionButton(context, status),
            appBar: AppBar(
              title: Text('Run'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _attemptDelete(context),
                ),
              ],
            ),
            drawer: UserDrawer(),
          );
        },
      );

  /// Builds the append button for the delivery list
  Widget _buildAppendButton(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
          title: Center(
            child: Icon(Icons.add),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => EditDeliveryPage(run: run)));
          },
        ),
      );

  /// Builds the floating action button for the scaffold
  Widget _buildFloatingActionButton(BuildContext context, Status status) {
    if (status == Status.complete) return null;

    if (status == Status.inProgress) {
      return FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () => _continue(context),
      );
    }

    return FloatingActionButton(
      child: const Icon(Icons.play_arrow),
      onPressed: () => _begin(context),
    );
  }

  /// Prompts the user to confirm run deletion
  void _attemptDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Delete run?'),
            content:
                Text('This will delete the selected run and all of its data.'),
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

  /// Deletes the run from the database
  void _delete(BuildContext context) async {
    _firestore.runTransaction((tx) async {
      await tx.delete(run.reference);
    });
    Navigator.pop(context);
  }

  /// Begins the run
  void _begin(BuildContext context) async {
    final hereNow = await SpaceTimeStamp.hereNow();

    final first = (await run.reference.collection('deliveries').getDocuments())
        .documents
        .first;
    _firestore.runTransaction((tx) async {
      final first =
          (await run.reference.collection('deliveries').getDocuments())
              .documents
              .first;
      await tx.update(first.reference, {'leaveStamp': hereNow.toMap()});
    });

    var uri = Uri.https('www.google.com', 'maps/dir/', {
      'api': '1',
      'origin': '${hereNow.space.latitude},${hereNow.space.longitude}',
      'destination': Delivery.fromSnapshot(first).address,
    });
    await launch(uri.toString());
  }

  /// Continues the run
  void _continue(BuildContext context) async {}
}
