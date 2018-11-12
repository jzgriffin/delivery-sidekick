import 'package:delivery_sidekick/card/job_card.dart';
import 'package:delivery_sidekick/model/job.dart';
import 'package:delivery_sidekick/page/add_job_page.dart';
import 'package:delivery_sidekick/session.dart';
import 'package:delivery_sidekick/widget/drawer.dart';
import 'package:flutter/material.dart';

/// Widget for displaying the jobs list
class JobsPage extends StatelessWidget {
  /// Instance of the application session
  final _session = Session();

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: _session.user.jobSnapshots(),
            builder: (context, AsyncSnapshot<List<Job>> snapshot) {
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

              return ListView(
                children:
                    snapshot.data.map((job) => JobCard(job: job)).toList(),
              );
            }), // TODO
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddJobPage())),
        ),
        appBar: AppBar(
          title: Text('Jobs'),
        ),
        drawer: UserDrawer(),
      );
}
