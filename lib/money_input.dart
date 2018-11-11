import 'package:flutter/material.dart';
import 'package:money/money.dart';

import 'currencies.dart';

typedef void MoneyChangedCallback(Money value);

class MoneyInput extends StatefulWidget {
  final Money value;
  final MoneyChangedCallback onChanged;

  MoneyInput({@required this.value, @required this.onChanged});

  @override
  createState() => _MoneyInputState();
}

class _MoneyInputState extends State<MoneyInput> {
  String _amount;
  String _symbol = 'USD';
  Money _money;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _onAmountChanged,
            ),
          ),
          SizedBox(width: 8.0),
          DropdownButton<String>(
            hint: Text('Currency'),
            value: _symbol,
            onChanged: _onSymbolChanged,
            items: currencySymbols
                .map((symbol) => DropdownMenuItem<String>(
                      value: symbol,
                      child: Text(symbol),
                    ))
                .toList(),
          ),
        ],
      );

  void _update() {
    try {
      _money = Money.fromString(_amount, Currency(_symbol));
    } catch (e) {
      _money = null;
    }

    widget.onChanged(_money);
  }

  void _onAmountChanged(String value) {
    setState(() {
      _amount = value;
      _update();
    });
  }

  void _onSymbolChanged(String value) {
    setState(() {
      _symbol = value;
      _update();
    });
  }
}
