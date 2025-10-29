import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final int endValue;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String? leftText;
  final String? rightText;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.endValue,
    this.duration = const Duration(seconds: 2),
    this.style,
    this.leftText,
    this.rightText = '',
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: endValue),
      duration: duration,

      builder: (context, value, child) {
        return Text(style: style, "$leftText$prefix$value$suffix$rightText");
      },
    );
  }
}
