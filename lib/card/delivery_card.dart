import 'package:delivery_sidekick/model/delivery.dart';
import 'package:delivery_sidekick/page/delivery_page.dart';
import 'package:flutter/material.dart';

/// Card widget for an individual delivery
class DeliveryCard extends StatelessWidget {
  /// Delivery to display the card of
  final Delivery delivery;

  /// Constructs a class instance
  DeliveryCard({@required this.delivery});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) {
    Widget icon;
    if (delivery.leaveStamp == null) {
      icon = Icon(Icons.access_time);
    } else if (delivery.returnStamp == null) {
      icon = Icon(Icons.time_to_leave);
    } else {
      icon = Icon(Icons.done);
    }

    var price = delivery.totalPrice();
    var tender = delivery.totalTender();
    var subtitleChildren = <Widget>[
      Row(
        children: [
          Text('Price: '),
          Text('$price'),
        ],
      ),
    ];
    if (tender.amount > 0) {
      subtitleChildren.add(Row(
        children: [
          Text('Tender: '),
          Text('$tender'),
        ],
      ));
      subtitleChildren.add(Row(
        children: [
          Text('Tip: '),
          Text('${tender - price}'),
        ],
      ));
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          leading: icon,
          title: Text(delivery.address),
          subtitle: Column(
            children: subtitleChildren,
          ),
          trailing: const Icon(Icons.navigate_next),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DeliveryPage(delivery: delivery))),
        ),
      ),
    );
  }
}
