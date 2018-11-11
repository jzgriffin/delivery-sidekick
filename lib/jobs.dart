import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_job.dart';
import 'drawer.dart';

/// Widget for displaying the jobs list
class JobsPage extends StatefulWidget {
  /// The current signed-in user
  final FirebaseUser user;

  /// Constructs this widget instance
  JobsPage({@required this.user});

  /// Creates the mutable state for this widget
  @override
  createState() => _JobsPageState();
}

/// State for the jobs page
class _JobsPageState extends State<JobsPage> {
  /// Instance of the Cloud Firestore library
  final _firestore = Firestore.instance;

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: _firestore
                .collection('users/${widget.user.uid}/jobs')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                children: snapshot.data.documents
                    .map((document) => _buildCard(document))
                    .toList(),
              );
            }), // TODO
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: _add, // TODO
        ),
        appBar: AppBar(
          title: Text('Jobs'),
        ),
        drawer: UserDrawer(user: widget.user),
      );

  Widget _buildCard(DocumentSnapshot document) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(),
          child: _buildTile(document),
        ),
      );

  Widget _buildTile(DocumentSnapshot document) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        leading: const Icon(Icons.work),
        title: Text('${document.data['name']}'),
        subtitle: document.data['address'] == null
            ? null
            : Text('${document.data['address']}'),
        trailing: const Icon(Icons.navigate_next),
        onTap: () {}, // TODO
      );

  // Pushes the page for adding a job
  void _add() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddJobPage(user: widget.user)));
  }
}
