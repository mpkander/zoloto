import 'package:example/src/models/bank_screen_data.dart';
import 'package:example/src/models/card_data.dart';
import 'package:example/src/models/transaction.dart';
import 'package:example/src/screens/bank_screen.dart';
import 'package:example/src/services/bank_service.dart';
import 'package:example/src/services/bank_service_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoloto/zoloto.dart';

class MockBankService extends Mock implements BankService {}

final _sampleLoaded = BankScreenDataLoaded(
  card: const CardData(
    maskedNumber: '•••• 4567',
    balance: '₽ 142 830,50',
    holderName: 'MARK ABRAMENKO',
    paymentSystem: PaymentSystem.visa,
  ),
  transactions: [
    const Transaction(
      name: 'Самокат',
      amount: '−₽ 1 240',
      date: '13 мар',
      categoryIcon: Icons.restaurant,
    ),
    const Transaction(
      name: 'Перевод Лизе',
      amount: '−₽ 5 000',
      date: '12 мар',
      categoryIcon: Icons.send,
    ),
    const Transaction(
      name: 'Зарплата',
      amount: '+₽ 95 000',
      date: '10 мар',
      categoryIcon: Icons.account_balance,
    ),
    const Transaction(
      name: 'Spotify',
      amount: '−₽ 299',
      date: '9 мар',
      categoryIcon: Icons.music_note,
    ),
    const Transaction(
      name: 'Пятёрочка',
      amount: '−₽ 2 870',
      date: '8 мар',
      categoryIcon: Icons.shopping_cart,
    ),
    const Transaction(
      name: 'Аптека',
      amount: '−₽ 650',
      date: '7 мар',
      categoryIcon: Icons.local_pharmacy,
    ),
    const Transaction(
      name: 'Такси',
      amount: '−₽ 430',
      date: '6 мар',
      categoryIcon: Icons.local_taxi,
    ),
    const Transaction(
      name: 'Самокат',
      amount: '−₽ 2 870',
      date: '8 мар',
      categoryIcon: Icons.shopping_cart,
    ),
  ],
);

Widget _wrapWithService(BankScreenData data) {
  final mock = MockBankService();
  when(() => mock.getData()).thenReturn(data);
  return BankServiceScope(service: mock, child: const BankScreen());
}

void main() {
  testGoldenWidgets('bank screen — data state', (tester) async {
    await expectMatchTestEnvironments(
      'bank_screen.data',
      tester: tester,
      widget: _wrapWithService(_sampleLoaded),
    );
    await expectMatchTestEnvironments(
      'bank_screen.data.scrolled',
      tester: tester,
      widget: _wrapWithService(_sampleLoaded),
      customPump: (t) async {
        await t.pumpAndSettle();
        await t.drag(find.byType(CustomScrollView), const Offset(0, -300));
        await t.pumpAndSettle();
      },
    );
  });

  testGoldenWidgets('bank screen — loading state', (tester) async {
    await expectMatchTestEnvironments(
      'bank_screen.loading',
      tester: tester,
      widget: _wrapWithService(const BankScreenDataLoading()),
      customPump: (tester) => tester.pump(const Duration(milliseconds: 500)),
    );
  });

  testGoldenWidgets('bank screen — error state', (tester) async {
    await expectMatchTestEnvironments(
      'bank_screen.error',
      tester: tester,
      widget: _wrapWithService(const BankScreenDataError('Ошибка загрузки данных')),
    );
  });

  testGoldenWidgets('bank screen — auto-height', (tester) async {
    await expectMatchTestEnvironments(
      'bank_screen.auto_height',
      tester: tester,
      widget: _wrapWithService(_sampleLoaded),
      testEnvironments: [TestEnvironments.iphone13Mini.copyWith(autoHeight: true)],
    );
  });

  testGoldenWidgets('bank screen — custom devices', (tester) async {
    await expectMatchTestEnvironments(
      'bank_screen.custom_devices',
      tester: tester,
      widget: _wrapWithService(_sampleLoaded),
      testEnvironments: [
        const TestEnvironment(
          name: 'custom_safe_area',
          size: Size(375, 812),
          safeArea: EdgeInsets.only(top: 60, bottom: 40),
          platform: TargetPlatform.iOS,
        ),
        const TestEnvironment(
          name: 'custom_pixel_ratio',
          size: Size(375, 812),
          pixelRatio: 2.0,
          platform: TargetPlatform.android,
        ),
        const TestEnvironment(
          name: 'custom_dark',
          size: Size(375, 812),
          brightness: Brightness.dark,
          platform: TargetPlatform.iOS,
        ),
        const TestEnvironment(
          name: 'custom_android',
          size: Size(412, 919),
          platform: TargetPlatform.android,
          safeArea: EdgeInsets.only(top: 24, bottom: 16),
        ),
      ],
    );
  });
}
