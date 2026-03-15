import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({super.key});

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _ShimmerBox(
                width: double.infinity,
                height: 200,
                borderRadius: 20,
                animationValue: _controller.value,
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < 5; i++) ...[
                _ShimmerTransactionItem(animationValue: _controller.value),
                if (i < 4) const SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerTransactionItem extends StatelessWidget {
  const _ShimmerTransactionItem({required this.animationValue});

  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBox(
          width: 44,
          height: 44,
          borderRadius: 12,
          animationValue: animationValue,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(
                width: 120,
                height: 14,
                borderRadius: 4,
                animationValue: animationValue,
              ),
              const SizedBox(height: 6),
              _ShimmerBox(
                width: 80,
                height: 12,
                borderRadius: 4,
                animationValue: animationValue,
              ),
            ],
          ),
        ),
        _ShimmerBox(
          width: 60,
          height: 14,
          borderRadius: 4,
          animationValue: animationValue,
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animationValue,
  });

  final double width;
  final double height;
  final double borderRadius;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(-1.0 + 2.0 * animationValue, 0),
          end: Alignment(1.0 + 2.0 * animationValue, 0),
          colors: const [
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
