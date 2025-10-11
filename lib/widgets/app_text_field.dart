import 'package:flutter/material.dart';

// --- Reusable AppTextField  ---

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  final String? Function(String?)? validator;

  const AppTextField({
   super.key,
    this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.labelStyle,
    this.hintStyle,

    this.validator,
  }) ;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: _isObscured,

        keyboardType: widget.keyboardType ?? TextInputType.text,
        validator: widget.validator,
        style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: widget.label ?? 'Label',
          hintText: widget.hintText ?? 'Enter something',
          labelStyle:
              widget.labelStyle ??
              TextStyle(
                color: colorScheme.onSurface.withAlpha((153)),

                fontSize: 14,
              ),
          hintStyle:
              widget.hintStyle ??
              TextStyle(
                color: colorScheme.onSurface.withAlpha((153)),
                fontSize: 16,
              ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: _buildSuffixIcon(colorScheme),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colorScheme.onSurface.withAlpha((153)),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colorScheme.onSurface.withAlpha((153)),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.primary),
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        onPressed:
            widget.enabled
                ? () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                }
                : null,
      );
    }
    return widget.suffixIcon;
  }
}
