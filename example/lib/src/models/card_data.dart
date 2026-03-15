import 'package:flutter/foundation.dart';

enum PaymentSystem { visa, mastercard, amex }

@immutable
class CardData {
  const CardData({
    required this.maskedNumber,
    required this.balance,
    required this.holderName,
    required this.paymentSystem,
  });

  final String maskedNumber;
  final String balance;
  final String holderName;
  final PaymentSystem paymentSystem;
}
