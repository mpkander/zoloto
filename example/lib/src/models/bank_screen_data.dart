import 'package:flutter/foundation.dart';

import 'card_data.dart';
import 'transaction.dart';

sealed class BankScreenData {
  const BankScreenData();
}

@immutable
class BankScreenDataLoaded extends BankScreenData {
  const BankScreenDataLoaded({
    required this.card,
    required this.transactions,
  });

  final CardData card;
  final List<Transaction> transactions;
}

@immutable
class BankScreenDataLoading extends BankScreenData {
  const BankScreenDataLoading();
}

@immutable
class BankScreenDataError extends BankScreenData {
  const BankScreenDataError(this.message);

  final String message;
}
