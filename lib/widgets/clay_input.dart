import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/clay_colors.dart';
import '../theme/clay_shadows.dart';

class ClayInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool showPasswordToggle;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  const ClayInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
    this.maxLines,
    this.onChanged,
  });

  @override
  State<ClayInput> createState() => _ClayInputState();
}

class _ClayInputState extends State<ClayInput> {
  bool _focused = false;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffix = widget.suffixIcon;
    if (widget.showPasswordToggle) {
      suffix = IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 20,
          color: ClayColors.textMuted,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }

    final isMultiline = widget.maxLines != null && widget.maxLines! > 1;

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: ClayColors.surfaceAlt,
          borderRadius: BorderRadius.circular(isMultiline ? 16 : 24),
          boxShadow: _focused
              ? [...ClayShadows.inner, ...ClayShadows.glow]
              : ClayShadows.inner,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isMultiline ? 10 : 4,
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          // maxLines terbatas agar text field tidak terus mengembang
          maxLines: widget.obscureText ? 1 : (widget.maxLines ?? 1),
          minLines: 1,
          // Pastikan teks panjang wrap, bukan scroll horizontal
          textAlignVertical: TextAlignVertical.top,
          onChanged: widget.onChanged,
          style: const TextStyle(overflow: TextOverflow.visible),
          decoration: InputDecoration(
            labelText: widget.label,
            border: InputBorder.none,
            suffixIcon: suffix,
            isDense: true,
            contentPadding: isMultiline
                ? const EdgeInsets.symmetric(vertical: 4)
                : EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
