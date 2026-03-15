import 'package:flutter/material.dart';

import 'src/models/bank_screen_data.dart';
import 'src/models/card_data.dart';
import 'src/models/transaction.dart';
import 'src/screens/bank_screen.dart';
import 'src/services/bank_service.dart';
import 'src/services/bank_service_scope.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Manrope'),
          displayMedium: TextStyle(fontFamily: 'Manrope'),
          displaySmall: TextStyle(fontFamily: 'Manrope'),
          headlineLarge: TextStyle(fontFamily: 'Manrope'),
          headlineMedium: TextStyle(fontFamily: 'Manrope'),
          headlineSmall: TextStyle(fontFamily: 'Manrope'),
          titleLarge: TextStyle(fontFamily: 'Manrope'),
          titleMedium: TextStyle(fontFamily: 'Manrope'),
          titleSmall: TextStyle(fontFamily: 'Manrope'),
          bodyLarge: TextStyle(fontFamily: 'Manrope'),
          bodyMedium: TextStyle(fontFamily: 'Manrope'),
          bodySmall: TextStyle(fontFamily: 'Manrope'),
          labelLarge: TextStyle(fontFamily: 'Manrope'),
          labelMedium: TextStyle(fontFamily: 'Manrope'),
          labelSmall: TextStyle(fontFamily: 'Manrope'),
        ),
      ),
      home: BankServiceScope(
        service: _createSampleService(),
        child: const BankScreen(),
      ),
    );
  }
}

BankService _createSampleService() {
  final service = BankService();
  service.setData(
    BankScreenDataLoaded(
      card: const CardData(
        maskedNumber: '•••• 4567',
        balance: '₽ 142 830,50',
        holderName: 'MARK ABRAMENKO',
        paymentSystem: PaymentSystem.mastercard,
      ),
      transactions: [
        const Transaction(
          name: 'Еда',
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
      ],
    ),
  );
  return service;
}
