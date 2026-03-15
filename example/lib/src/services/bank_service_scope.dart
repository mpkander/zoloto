import 'package:flutter/widgets.dart';

import 'bank_service.dart';

class BankServiceScope extends InheritedWidget {
  const BankServiceScope({
    super.key,
    required this.service,
    required super.child,
  });

  final BankService service;

  static BankService of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<BankServiceScope>();
    assert(scope != null, 'No BankServiceScope found in context');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(BankServiceScope oldWidget) =>
      service != oldWidget.service;
}
