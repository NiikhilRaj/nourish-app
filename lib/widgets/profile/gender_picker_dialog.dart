import 'package:flutter/material.dart';
import 'horizontal_gender_picker.dart';

class GenderPickerDialog extends StatefulWidget {
  final String initialGender;

  const GenderPickerDialog({
    super.key,
    required this.initialGender,
  });

  static Future<String?> show(BuildContext context, String initialGender) {
    return showDialog<String>(
      context: context,
      builder: (context) => GenderPickerDialog(initialGender: initialGender),
    );
  }

  @override
  State<GenderPickerDialog> createState() => _GenderPickerDialogState();
}

class _GenderPickerDialogState extends State<GenderPickerDialog> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xff6F60EF);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: primaryColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      backgroundColor: isDark ? const Color(0xff1F1E23) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Gender',
              style: TextStyle(
                fontFamily: 'Chivo',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            HorizontalGenderPicker(
              selectedGender: _selectedGender,
              onChanged: (newGender) {
                setState(() {
                  _selectedGender = newGender;
                });
              },
            ),
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
                  onPressed: () => Navigator.of(context).pop(_selectedGender),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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
