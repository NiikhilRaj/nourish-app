import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileInputDialog extends StatefulWidget {
  final String label;
  final String initialValue;
  final TextInputType keyboardType;
  final String? suffix;
  final int? minValue;
  final int? maxValue;

  const ProfileInputDialog({
    super.key,
    required this.label,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.minValue,
    this.maxValue,
  });

  static Future<String?> show(
    BuildContext context, {
    required String label,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
    int? minValue,
    int? maxValue,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => ProfileInputDialog(
        label: label,
        initialValue: initialValue,
        keyboardType: keyboardType,
        suffix: suffix,
        minValue: minValue,
        maxValue: maxValue,
      ),
    );
  }

  @override
  State<ProfileInputDialog> createState() => _ProfileInputDialogState();
}

class _ProfileInputDialogState extends State<ProfileInputDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate(String value) {
    if (widget.minValue != null || widget.maxValue != null) {
      final parsed = double.tryParse(value);
      if (parsed == null) {
        setState(() => _errorText = 'Enter a valid number');
      } else if (widget.minValue != null && parsed < widget.minValue!) {
        setState(() => _errorText = 'Must be at least ${widget.minValue}');
      } else if (widget.maxValue != null && parsed > widget.maxValue!) {
        setState(() => _errorText = 'Must be at most ${widget.maxValue}');
      } else {
        setState(() => _errorText = null);
      }
    } else {
      setState(() => _errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xff6F60EF);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? const Color(0xff1F1E23) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit ${widget.label}',
              style: TextStyle(
                fontFamily: 'Chivo',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff2A2A2A) : const Color(0xffF3EFEF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _errorText != null ? const Color(0xffF44336) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: widget.keyboardType,
                        autofocus: true,
                        inputFormatters: [
                          if (widget.keyboardType == TextInputType.number ||
                              widget.keyboardType ==
                                  const TextInputType.numberWithOptions(decimal: true))
                            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontSize: 20,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter value',
                          hintStyle: TextStyle(
                            color: isDark ? const Color(0xff636364) : const Color(0xff919297),
                          ),
                        ),
                        onChanged: _validate,
                      ),
                    ),
                    if (widget.suffix != null)
                      Text(
                        widget.suffix!,
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontSize: 16,
                          color: isDark ? const Color(0xff636364) : const Color(0xff919297),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 6),
              Text(
                _errorText!,
                style: const TextStyle(
                  fontFamily: 'Chivo',
                  fontSize: 12,
                  color: Color(0xffF44336),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      color: isDark ? const Color(0xff919297) : const Color(0xff636364),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _errorText == null
                      ? () => Navigator.of(context).pop(_controller.text.trim())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: primaryColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
