import 'package:money/money.dart';

import 'mileage_unit.dart';
import 'money.dart';

class Mileage {
  Money rate;
  num divisor;
  MileageUnit unit;

  Mileage({this.rate, this.divisor, this.unit});

  factory Mileage.fromMap(Map map) => map == null
      ? null
      : Mileage(
          rate: moneyFromMap(map['rate']),
          divisor: map['divisor'],
          unit: mileageUnitFromString(map['unit']),
        );

  Map<String, dynamic> toMap() => {
        'rate': moneyToMap(rate),
        'divisor': divisor,
        'unit': mileageUnitToString(unit),
      };
}
