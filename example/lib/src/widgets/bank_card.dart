import 'package:flutter/material.dart';

import '../models/card_data.dart';

class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.data,
    this.brightness = Brightness.dark,
  });

  final CardData data;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryColor =
        isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.wifi, color: secondaryColor, size: 28),
                SizedBox(
                  height: 32,
                  child: Image.asset(
                    _logoAsset(data.paymentSystem),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              data.maskedNumber,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              data.balance,
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.holderName,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _logoAsset(PaymentSystem system) => switch (system) {
        PaymentSystem.visa => 'assets/images/wallet_visa.webp',
        PaymentSystem.mastercard => 'assets/images/wallet_mastercard.webp',
        PaymentSystem.amex => 'assets/images/wallet_amex.webp',
      };
}
