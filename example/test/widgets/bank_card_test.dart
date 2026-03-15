import 'package:example/src/models/card_data.dart';
import 'package:example/src/widgets/bank_card.dart';
import 'package:flutter/material.dart';
import 'package:zoloto/zoloto.dart';

const _cardTestCase = TestEnvironment(
  name: 'card',
  size: Size(460, 280),
  pixelRatio: 2,
  surfacePadding: EdgeInsets.all(16),
  safeArea: EdgeInsets.zero,
  platform: TargetPlatform.android,
);

const _visaCard = CardData(
  maskedNumber: '•••• 4567',
  balance: '₽ 142 830,50',
  holderName: 'MARK ABRAMENKO',
  paymentSystem: PaymentSystem.visa,
);

const _mastercardCard = CardData(
  maskedNumber: '•••• 8901',
  balance: '€ 3 250,00',
  holderName: 'LIZA ABRAMENKO',
  paymentSystem: PaymentSystem.mastercard,
);

const _amexCard = CardData(
  maskedNumber: '•••• 2345',
  balance: '\$ 12 500.00',
  holderName: 'JOHN DOE',
  paymentSystem: PaymentSystem.amex,
);

void main() {
  testGoldenWidgets('bank card — visa', (tester) async {
    await expectMatchTestEnvironments(
      'bank_card.visa',
      tester: tester,
      widget: const BankCard(data: _visaCard),
      testEnvironments: [_cardTestCase],
    );
  });

  testGoldenWidgets('bank card — mastercard', (tester) async {
    await expectMatchTestEnvironments(
      'bank_card.mastercard',
      tester: tester,
      widget: const BankCard(data: _mastercardCard),
      testEnvironments: [_cardTestCase],
    );
  });

  testGoldenWidgets('bank card — amex', (tester) async {
    await expectMatchTestEnvironments(
      'bank_card.amex',
      tester: tester,
      widget: const BankCard(data: _amexCard),
      testEnvironments: [_cardTestCase],
    );
  });

  testGoldenWidgets('bank card — light brightness', (tester) async {
    await expectMatchTestEnvironments(
      'bank_card.visa.light',
      tester: tester,
      widget: const BankCard(data: _visaCard, brightness: Brightness.light),
      testEnvironments: [_cardTestCase],
    );
  });

  testGoldenWidgets('bank card — dark brightness', (tester) async {
    await expectMatchTestEnvironments(
      'bank_card.visa.dark',
      tester: tester,
      widget: const BankCard(data: _visaCard, brightness: Brightness.dark),
      testEnvironments: [_cardTestCase],
    );
  });
}
