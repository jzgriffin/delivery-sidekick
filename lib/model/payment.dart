import 'package:money/money.dart';

import 'money.dart';
import 'payment_method.dart';

class Payment {
  PaymentMethod method;
  Money money;

  Payment({this.method, this.money});

  factory Payment.fromMap(Map map) => map == null
      ? null
      : Payment(
          method: paymentMethodFromString(map['method']),
          money: moneyFromMap(map['money']),
        );

  Map<String, dynamic> toMap() => {
        'method': paymentMethodToString(method),
        'money': moneyToMap(money),
      };

  static List<Payment> fromMaps(List maps) =>
      maps.map((x) => Payment.fromMap(x)).toList();
  static List<Map<String, dynamic>> toMaps(List<Payment> payments) =>
      payments.map((x) => x.toMap()).toList();

  static Money sum(List<Payment> payments) => payments.isEmpty ||
          payments[0].money == null ||
          payments[0].money.amount == null ||
          payments[0].money.currency == null
      ? Money(0, Currency('USD'))
      : payments.fold(
          Money(0, payments[0].money.currency),
          ((t, p) => p.money != null &&
                  p.money.amount != null &&
                  p.money.currency != null
              ? t + p.money
              : t));
}
