import 'package:delivery_sidekick/model/delivery.dart';
import 'package:delivery_sidekick/widget/drawer.dart';
import 'package:flutter/material.dart';

/// Widget for displaying an individual delivery
class DeliveryPage extends StatelessWidget {
  /// Delivery to display
  final Delivery delivery;

  /// Constructs a class instance
  DeliveryPage({@required this.delivery});

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(),
        appBar: AppBar(
          title: Text('Delivery'),
        ),
        drawer: UserDrawer(),
      );
}
