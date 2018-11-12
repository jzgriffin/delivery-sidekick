import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_sidekick/model/delivery.dart';
import 'package:delivery_sidekick/model/payment.dart';
import 'package:delivery_sidekick/model/payment_method.dart';
import 'package:delivery_sidekick/model/run.dart';
import 'package:delivery_sidekick/session.dart';
import 'package:delivery_sidekick/widget/money_input.dart';
import 'package:flutter/material.dart';

/// Widget for entering a new job
class EditDeliveryPage extends StatefulWidget {
  /// Run to add the delivery to
  final Run run;

  /// Delivery to modify, if any
  final Delivery delivery;

  /// Constructs a class instance
  EditDeliveryPage({@required this.run, this.delivery});

  /// Creates the mutable state for this widget
  @override
  createState() => _EditDeliveryPageState();
}

/// State for the add job page
class _EditDeliveryPageState extends State<EditDeliveryPage> {
  /// Instance of the Firestore database
  final _firestore = Firestore.instance;

  /// Instance of the application session
  final _session = Session();

  /// Key for the entire job form
  final _formKey = GlobalKey<FormState>();

  /// Delivery assembled from the form
  Delivery _delivery;

  /// Called when this object is inserted into the tree
  @override
  void initState() {
    super.initState();

    _delivery = widget.delivery ??
        Delivery(
          price: [Payment()],
          tender: [],
        );
  }

  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildForm(),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('Add delivery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: _confirm,
            )
          ],
        ),
      );

  /// Builds a child widget list for the form
  List<Widget> _buildForm() => [
        _buildField(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Address'),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
            onSaved: (value) => _delivery.address = value,
          ),
        ),
        Text('Price - Total: ${_delivery.totalPrice()}'),
        Column(
          children: _buildPaymentItems(_delivery.price),
        ),
        Text('Tender - Total: ${_delivery.totalTender()}'),
        Column(
          children: _buildPaymentItems(_delivery.tender),
        ),
      ];

  Widget _buildPaymentItem(List<Payment> array, Payment payment) => Row(
        children: [
          DropdownButton<PaymentMethod>(
            hint: Text('Method'),
            value: payment.method,
            onChanged: (value) => setState(() => payment.method = value),
            items: paymentMethods.entries
                .map((entry) => DropdownMenuItem<PaymentMethod>(
                      value: entry.value,
                      child: Text(entry.key),
                    ))
                .toList(),
          ),
          SizedBox(width: 8.0),
          Flexible(
              child: MoneyInput(
            value: payment.money,
            onChanged: (value) => setState(() => payment.money = value),
          )),
          SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => setState(() => array.remove(payment)),
          ),
        ],
      );

  List<Widget> _buildPaymentItems(List<Payment> array) {
    var children = array.map((x) => _buildPaymentItem(array, x)).toList();
    children.add(ListTile(
      title: Center(
        child: Icon(Icons.add),
      ),
      onTap: () => setState(() => array.add(Payment())),
    ));
    return children;
  }

  /// Builds a containing widget for displaying a form field
  Widget _buildField(
          {Widget child,
          EdgeInsets padding = const EdgeInsets.only(bottom: 8.0)}) =>
      Padding(padding: padding, child: child);

  /// Validates the form and saves its state when valid
  bool _validate() {
    final form = _formKey.currentState;
    if (!form.validate()) return false;

    form.save();

    // TODO: Validation

    return true;
  }

  /// Confirms the addition of the delivery to the database
  void _confirm() async {
    if (!_validate()) return;

    await widget.run.reference.collection('deliveries').add(_delivery.toMap());
    Navigator.pop(context);
  }
}
