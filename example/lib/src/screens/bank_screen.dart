import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/bank_screen_data.dart';
import '../services/bank_service_scope.dart';
import '../widgets/bank_card.dart';
import '../widgets/shimmer_skeleton.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = BankServiceScope.of(context).getData();

    return Scaffold(
      body: switch (data) {
        BankScreenDataLoaded loaded => _DataView(data: loaded),
        BankScreenDataLoading() => const _LoadingView(),
        BankScreenDataError error => _ErrorView(message: error.message),
      },
    );
  }
}

class _DataView extends StatelessWidget {
  const _DataView({required this.data});

  final BankScreenDataLoaded data;

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);

    return CustomScrollView(
      slivers: [
        _BlurAppBar(title: 'Мой банк'),
        SliverToBoxAdapter(child: BankCard(data: data.card)),
        SliverPadding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + safeArea.bottom,
          ),
          sliver: SliverList.builder(
            itemCount: data.transactions.length,
            itemBuilder: (context, index) {
              final tx = data.transactions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      tx.categoryIcon,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(tx.name),
                  subtitle: Text(
                    tx.date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    tx.amount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _BlurAppBar(title: 'Мой банк'),
        SliverToBoxAdapter(child: ShimmerSkeleton()),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const _BlurAppBar(title: 'Мой банк'),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: () {}, child: const Text('Повторить')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BlurAppBar extends StatelessWidget {
  const _BlurAppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
