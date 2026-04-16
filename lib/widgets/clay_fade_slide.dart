import 'package:flutter/material.dart';

class ClayFadeSlide extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;

  const ClayFadeSlide({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(milliseconds: 40),
  });

  @override
  State<ClayFadeSlide> createState() => _ClayFadeSlideState();
}

class _ClayFadeSlideState extends State<ClayFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    final delay = Duration(
      milliseconds: widget.baseDelay.inMilliseconds * widget.index,
    );
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final value = _curve.value;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
