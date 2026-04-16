import 'package:flutter/material.dart';
import 'clay_colors.dart';

class ClayShadows {
  static List<BoxShadow> card = [
    const BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 18,
      offset: Offset(6, 8),
    ),
    const BoxShadow(
      color: Color(0x4DFFFFFF),
      blurRadius: 14,
      offset: Offset(-6, -6),
    ),
  ];

  static List<BoxShadow> surface = [
    const BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(4, 6),
    ),
    const BoxShadow(
      color: Color(0x66FFFFFF),
      blurRadius: 10,
      offset: Offset(-4, -4),
    ),
  ];

  static List<BoxShadow> button = [
    const BoxShadow(
      color: Color(0x22000000),
      blurRadius: 16,
      offset: Offset(6, 8),
    ),
    const BoxShadow(
      color: Color(0x66FFFFFF),
      blurRadius: 14,
      offset: Offset(-6, -6),
    ),
  ];

  static List<BoxShadow> pressed = [
    const BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(2, 3),
    ),
    const BoxShadow(
      color: Color(0x33FFFFFF),
      blurRadius: 8,
      offset: Offset(-2, -2),
    ),
  ];

  static List<BoxShadow> inner = [
    const BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(2, 2),
    ),
    const BoxShadow(
      color: Color(0x80FFFFFF),
      blurRadius: 6,
      offset: Offset(-2, -2),
    ),
  ];

  static List<BoxShadow> glow = [
    BoxShadow(
      color: ClayColors.primary.withAlpha(64),
      blurRadius: 12,
      offset: const Offset(0, 0),
    ),
  ];
}
