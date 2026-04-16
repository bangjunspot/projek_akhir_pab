import 'package:flutter/material.dart';
import '../theme/clay_colors.dart';
import '../theme/clay_shadows.dart';

enum ClayElevation { surface, card }

class ClayCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final ClayElevation elevation;

  const ClayCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.elevation = ClayElevation.card,
  });

  @override
  State<ClayCard> createState() => _ClayCardState();
}

class _ClayCardState extends State<ClayCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final baseShadows = widget.elevation == ClayElevation.card
        ? ClayShadows.card
        : ClayShadows.surface;

    final shadows = _pressed ? ClayShadows.pressed : baseShadows;
    final scale = _pressed ? 0.98 : (_hovered ? 1.01 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: widget.padding,
            decoration: BoxDecoration(
              color: ClayColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: shadows,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
