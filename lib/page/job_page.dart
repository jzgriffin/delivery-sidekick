import 'package:delivery_sidekick/card/shift_card.dart';
import 'package:delivery_sidekick/model/job.dart';
import 'package:delivery_sidekick/model/shift.dart';
import 'package:delivery_sidekick/page/shift_page.dart';
import 'package:delivery_sidekick/widget/drawer.dart';
import 'package:flutter/material.dart';

/// Widget for displaying individual jobs
class JobPage extends StatelessWidget {
  /// Job to display
  final Job job;

  /// Constructs a class instance
  JobPage({@required this.job});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: job.shiftSnapshots(),
            builder: (context, AsyncSnapshot<List<Shift>> snapshot) {
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
                children: snapshot.data
                    .map((shift) => ShiftCard(shift: shift))
                    .toList(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _startShift(context),
        ),
        appBar: AppBar(
          title: StreamBuilder(
              stream: job.snapshots(),
              builder: (context, AsyncSnapshot<Job> snapshot) {
                if (snapshot.hasError) {
                  // TODO: Error reporting
                  print('${snapshot.error}');
                  return Center(
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Text(snapshot.data.name);
              }),
        ),
        drawer: UserDrawer(),
      );

  /// Starts a new shift
  void _startShift(BuildContext context) async {
    var shift = Shift(startStamp: DateTime.now());
    shift.reference =
        await job.reference.collection('shifts').add(shift.toMap());
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ShiftPage(shift: shift)));
  }
}
