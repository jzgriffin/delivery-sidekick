import 'package:delivery_sidekick/model/delivery.dart';
import 'package:delivery_sidekick/model/run.dart';
import 'package:delivery_sidekick/page/run_page.dart';
import 'package:flutter/material.dart';

/// Card widget for an individual run
class RunCard extends StatelessWidget {
  /// Run to display the card of
  final Run run;

  /// Constructs a class instance
  RunCard({@required this.run});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          leading: const Icon(Icons.timelapse),
          title: Text(run.startStamp.toString()),
          subtitle: StreamBuilder(
              stream: run.deliverySnapshots(),
              builder: (context, AsyncSnapshot<List<Delivery>> snapshot) {
                if (snapshot.hasError) {
                  // TODO: Error reporting
                  print('${snapshot.error}');
                  return Center(
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Text('${snapshot.data.length} deliveries');
              }),
          trailing: const Icon(Icons.navigate_next),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => RunPage(run: run))),
        ),
      ),
    );
  }
}
