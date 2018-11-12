enum PaymentMethod { card, cash }

const paymentMethods = <String, PaymentMethod>{
  'card': PaymentMethod.card,
  'cash': PaymentMethod.cash,
};

String paymentMethodToString(PaymentMethod unit) => paymentMethods.entries
    .where((e) => e.value == unit)
    .map((e) => e.key)
    .single;
PaymentMethod paymentMethodFromString(String string) => paymentMethods.entries
    .where((e) => e.key == string)
    .map((e) => e.value)
    .single;
