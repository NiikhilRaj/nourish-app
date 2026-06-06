import 'package:flutter/material.dart';
import 'macros_edit_dialog.dart';

class ProfileMacrosWidget extends StatelessWidget {
  final int targetCalories;
  final int protein;
  final int carbs;
  final int fat;
  final bool isEditMode;
  final ValueChanged<int>? onCaloriesChanged;
  final ValueChanged<int>? onProteinChanged;
  final ValueChanged<int>? onCarbsChanged;
  final ValueChanged<int>? onFatChanged;

  const ProfileMacrosWidget({
    super.key,
    required this.targetCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isEditMode = false,
    this.onCaloriesChanged,
    this.onProteinChanged,
    this.onCarbsChanged,
    this.onFatChanged,
  });

  Future<void> _editMacros(BuildContext context) async {
    final result = await MacrosEditDialog.show(
      context,
      initialCalories: targetCalories,
      initialProtein: protein,
      initialFat: fat,
      initialCarbs: carbs,
    );
    if (result != null) {
      if (onCaloriesChanged != null) onCaloriesChanged!(result.calories);
      if (onProteinChanged != null) onProteinChanged!(result.protein);
      if (onFatChanged != null) onFatChanged!(result.fat);
      if (onCarbsChanged != null) onCarbsChanged!(result.carbs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color boxColor = isDark ? Colors.grey[850]! : const Color(0xffF3EFEF);
    final Color labelColor = isDark ? const Color(0xff919297) : const Color(0xff636364);
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color accentColor = const Color(0xff6F60EF);

    final macros = [
      _MacroItem('Protein', protein, 'g', const Color(0xff6F60EF)),
      _MacroItem('Fat', fat, 'g', const Color(0xffF44336)),
      _MacroItem('Carbs', carbs, 'g', const Color(0xffFFC009)),
    ];

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Macro Goals:',
                style: TextStyle(
                  fontFamily: 'Chivo',
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: labelColor,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    targetCalories == 0 ? 'Not Set' : '$targetCalories kcal',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: targetCalories == 0 ? labelColor : textColor,
                    ),
                  ),
                  if (isEditMode) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.edit_outlined, size: 14, color: accentColor),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: macros.map((m) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isEditMode
                        ? m.color.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isEditMode
                        ? Border.all(color: m.color.withValues(alpha: 0.3), width: 1)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.label,
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: isEditMode ? m.color : labelColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m.value == 0 ? '--' : '${m.value}${m.suffix}',
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

    if (isEditMode) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _editMacros(context),
            borderRadius: BorderRadius.circular(10),
            child: content,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );
  }
}

class _MacroItem {
  final String label;
  final int value;
  final String suffix;
  final Color color;

  const _MacroItem(this.label, this.value, this.suffix, this.color);
}
