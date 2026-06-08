import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MacroValues {
  final int calories;
  final int protein;
  final int fat;
  final int carbs;

  const MacroValues({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}

class MacrosEditDialog extends StatefulWidget {
  final int initialCalories;
  final int initialProtein;
  final int initialFat;
  final int initialCarbs;

  const MacrosEditDialog({
    super.key,
    required this.initialCalories,
    required this.initialProtein,
    required this.initialFat,
    required this.initialCarbs,
  });

  static Future<MacroValues?> show(
    BuildContext context, {
    required int initialCalories,
    required int initialProtein,
    required int initialFat,
    required int initialCarbs,
  }) {
    return showDialog<MacroValues>(
      context: context,
      builder: (context) => MacrosEditDialog(
        initialCalories: initialCalories,
        initialProtein: initialProtein,
        initialFat: initialFat,
        initialCarbs: initialCarbs,
      ),
    );
  }

  @override
  State<MacrosEditDialog> createState() => _MacrosEditDialogState();
}

class _MacrosEditDialogState extends State<MacrosEditDialog> {
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _carbsController;

  String? _caloriesError;
  String? _proteinError;
  String? _fatError;
  String? _carbsError;

  @override
  void initState() {
    super.initState();
    _caloriesController = TextEditingController(
      text: widget.initialCalories == 0 ? '' : widget.initialCalories.toString(),
    );
    _proteinController = TextEditingController(
      text: widget.initialProtein == 0 ? '' : widget.initialProtein.toString(),
    );
    _fatController = TextEditingController(
      text: widget.initialFat == 0 ? '' : widget.initialFat.toString(),
    );
    _carbsController = TextEditingController(
      text: widget.initialCarbs == 0 ? '' : widget.initialCarbs.toString(),
    );
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _validateCalories(String val) {
    if (val.isEmpty) {
      setState(() => _caloriesError = null);
      return;
    }
    final parsed = int.tryParse(val);
    if (parsed == null) {
      setState(() => _caloriesError = 'Invalid');
    } else if (parsed < 0 || parsed > 9999) {
      setState(() => _caloriesError = '0-9999');
    } else {
      setState(() => _caloriesError = null);
    }
  }

  void _validateProtein(String val) {
    if (val.isEmpty) {
      setState(() => _proteinError = null);
      return;
    }
    final parsed = int.tryParse(val);
    if (parsed == null) {
      setState(() => _proteinError = 'Invalid');
    } else if (parsed < 0 || parsed > 999) {
      setState(() => _proteinError = '0-999');
    } else {
      setState(() => _proteinError = null);
    }
  }

  void _validateFat(String val) {
    if (val.isEmpty) {
      setState(() => _fatError = null);
      return;
    }
    final parsed = int.tryParse(val);
    if (parsed == null) {
      setState(() => _fatError = 'Invalid');
    } else if (parsed < 0 || parsed > 999) {
      setState(() => _fatError = '0-999');
    } else {
      setState(() => _fatError = null);
    }
  }

  void _validateCarbs(String val) {
    if (val.isEmpty) {
      setState(() => _carbsError = null);
      return;
    }
    final parsed = int.tryParse(val);
    if (parsed == null) {
      setState(() => _carbsError = 'Invalid');
    } else if (parsed < 0 || parsed > 999) {
      setState(() => _carbsError = '0-999');
    } else {
      setState(() => _carbsError = null);
    }
  }

  bool get _isValid {
    return _caloriesError == null &&
        _proteinError == null &&
        _fatError == null &&
        _carbsError == null;
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required ValueChanged<String> onChanged,
    required Color color,
    String? errorText,
    bool isDark = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Chivo',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff2A2A2A) : const Color(0xffF3EFEF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null
                  ? const Color(0xffF44336)
                  : color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontFamily: 'Chivo',
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                suffix,
                style: TextStyle(
                  fontFamily: 'Chivo',
                  fontSize: 12,
                  color: isDark ? const Color(0xff636364) : const Color(0xff919297),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 2),
          Text(
            errorText,
            style: const TextStyle(
              fontFamily: 'Chivo',
              fontSize: 10,
              color: Color(0xffF44336),
            ),
          ),
        ],
      ],
    );
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Macro Goals',
                style: TextStyle(
                  fontFamily: 'Chivo',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildField(
                label: 'Calories',
                controller: _caloriesController,
                suffix: 'kcal',
                onChanged: _validateCalories,
                color: const Color(0xff6F60EF),
                errorText: _caloriesError,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildField(
                      label: 'Protein',
                      controller: _proteinController,
                      suffix: 'g',
                      onChanged: _validateProtein,
                      color: const Color(0xff6F60EF),
                      errorText: _proteinError,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildField(
                      label: 'Fat',
                      controller: _fatController,
                      suffix: 'g',
                      onChanged: _validateFat,
                      color: const Color(0xffF44336),
                      errorText: _fatError,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildField(
                      label: 'Carbs',
                      controller: _carbsController,
                      suffix: 'g',
                      onChanged: _validateCarbs,
                      color: const Color(0xffFFC009),
                      errorText: _carbsError,
                      isDark: isDark,
                    ),
                  ),
                ],
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
                    onPressed: _isValid
                        ? () {
                            final cal = int.tryParse(_caloriesController.text) ?? 0;
                            final pro = int.tryParse(_proteinController.text) ?? 0;
                            final fat = int.tryParse(_fatController.text) ?? 0;
                            final carb = int.tryParse(_carbsController.text) ?? 0;
                            Navigator.of(context).pop(
                              MacroValues(
                                calories: cal,
                                protein: pro,
                                fat: fat,
                                carbs: carb,
                              ),
                            );
                          }
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
      ),
    );
  }
}
