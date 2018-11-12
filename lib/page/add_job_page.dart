import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_sidekick/model/job.dart';
import 'package:delivery_sidekick/model/mileage.dart';
import 'package:delivery_sidekick/model/mileage_unit.dart';
import 'package:delivery_sidekick/session.dart';
import 'package:delivery_sidekick/widget/money_input.dart';
import 'package:flutter/material.dart';

/// Widget for entering a new job
class AddJobPage extends StatefulWidget {
  /// Creates the mutable state for this widget
  @override
  createState() => _AddJobPageState();
}

/// State for the add job page
class _AddJobPageState extends State<AddJobPage> {
  /// Instance of the Firestore database
  final _firestore = Firestore.instance;

  /// Instance of the application session
  final _session = Session();

  /// Key for the entire job form
  final _formKey = GlobalKey<FormState>();

  /// Job assembled from the form
  var _job = Job();

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
          title: Text('Add job'),
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
            decoration: InputDecoration(hintText: 'Name'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
            onSaved: (value) => _job.name = value,
          ),
        ),
        _buildField(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Address'),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => _job.address = value.isEmpty ? null : value,
          ),
        ),
        _buildField(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Phone number'),
            keyboardType: TextInputType.phone,
            onSaved: (value) => _job.phone = value.isEmpty ? null : value,
          ),
        ),
        _buildField(
          child: Row(
            children: [
              Text('Bank:'),
              SizedBox(width: 8.0),
              Flexible(
                child: MoneyInput(
                  value: _job.bank,
                  onChanged: (value) => setState(() => _job.bank = value),
                ),
              ),
            ],
          ),
        ),
        _buildField(
          child: Column(
            children: _buildMileage(),
          ),
        ),
      ];

  /// Builds a child widget list for the mileage row
  List<Widget> _buildMileage() {
    var children = <Widget>[
      Row(
        children: [
          Text('Pays mileage'),
          Switch(
            value: _job.mileage != null,
            onChanged: (value) => setState(() {
                  _job.mileage = value ? Mileage() : null;
                }),
          ),
        ],
      ),
    ];

    if (_job.mileage != null) {
      children.add(Column(
        children: [
          MoneyInput(
            value: _job.mileage.rate,
            onChanged: (value) => setState(() => _job.mileage.rate = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                child: Text('per'),
                padding: const EdgeInsets.only(right: 8.0),
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Divisor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: _validateMileageDivisor,
                  onSaved: (value) =>
                      setState(() => _job.mileage.divisor = num.parse(value)),
                ),
              ),
              SizedBox(width: 8.0),
              DropdownButton<MileageUnit>(
                hint: Text('Unit'),
                value: _job.mileage.unit,
                onChanged: (value) => setState(() => _job.mileage.unit = value),
                items: mileageUnits.entries
                    .map((entry) => DropdownMenuItem<MileageUnit>(
                          value: entry.value,
                          child: Text(entry.key),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ));
    }

    return children;
  }

  /// Builds a containing widget for displaying a form field
  Widget _buildField(
          {Widget child,
          EdgeInsets padding = const EdgeInsets.only(bottom: 8.0)}) =>
      Padding(padding: padding, child: child);

  String _validateMileageDivisor(String value) {
    if (value == null || value.isEmpty) return 'Required';
    if (num.tryParse(value) == null) return 'Must be a number';
    return null;
  }

  /// Validates the form and saves its state when valid
  bool _validate() {
    final form = _formKey.currentState;
    if (!form.validate()) return false;

    form.save();

    if (_job.mileage != null &&
        (_job.mileage.rate == null ||
            _job.mileage.divisor == null ||
            _job.mileage.unit == null)) {
      // TODO: Error reporting
      print('${_job.mileage.toMap()}');
      return false;
    }

    return true;
  }

  /// Confirms the addition of the job to the database
  void _confirm() async {
    if (!_validate()) return;

    await _firestore
        .collection('users/${_session.authUser.uid}/jobs')
        .add(_job.toMap());
    Navigator.pop(context);
  }
}
