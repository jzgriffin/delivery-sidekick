import 'package:delivery_sidekick/model/job.dart';
import 'package:delivery_sidekick/page/job_page.dart';
import 'package:flutter/material.dart';

/// Card widget for an individual job
class JobCard extends StatelessWidget {
  /// Job to display the card of
  final Job job;

  /// Constructs a class instance
  JobCard({@required this.job});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            leading: const Icon(Icons.work),
            title: Text(job.name),
            subtitle: job.address == null ? null : Text(job.address),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => JobPage(job: job))),
          ),
        ),
      );
}
