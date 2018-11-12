import 'package:delivery_sidekick/model/shift.dart';
import 'package:delivery_sidekick/page/shift_page.dart';
import 'package:flutter/material.dart';

/// Card widget for an individual shift
class ShiftCard extends StatelessWidget {
  /// Shift to display the card of
  final Shift shift;

  /// Constructs a class instance
  ShiftCard({@required this.shift});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) {
    final isCurrent = shift.endStamp == null;

    Widget icon;
    Widget subtitle;
    if (isCurrent) {
      icon = Icon(Icons.hourglass_full);
      subtitle = Text('Current');
    } else {
      icon = Icon(Icons.hourglass_empty);
      subtitle = Text('Duration'); // TODO
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          leading: icon,
          title: Text(shift.startStamp.toString()),
          subtitle: subtitle,
          trailing: const Icon(Icons.navigate_next),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ShiftPage(shift: shift))),
        ),
      ),
    );
  }
}
