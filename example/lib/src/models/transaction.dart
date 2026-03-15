import 'package:flutter/widgets.dart';

@immutable
class Transaction {
  const Transaction({
    required this.name,
    required this.amount,
    required this.date,
    required this.categoryIcon,
  });

  final String name;
  final String amount;
  final String date;
  final IconData categoryIcon;
}
