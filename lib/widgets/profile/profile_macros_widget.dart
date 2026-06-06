import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color boxColor = isDark ? Colors.grey[850]! : const Color(0xfff1efef);
    final Color labelColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color textColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
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
                if (!isEditMode)
                  Text(
                    '$targetCalories kcal',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      fontWeight: FontWeight.w100, // Thin
                      fontSize: 16,
                      color: textColor,
                    ),
                  )
                else
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue: targetCalories.toString(),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: 'Chivo',
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: textColor,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        suffixText: ' kcal',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val) ?? 0;
                        if (onCaloriesChanged != null) {
                          onCaloriesChanged!(parsed);
                        }
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroItem('P:', protein, onProteinChanged, isEditMode, textColor, labelColor),
                _buildMacroItem('F:', fat, onFatChanged, isEditMode, textColor, labelColor),
                _buildMacroItem('C:', carbs, onCarbsChanged, isEditMode, textColor, labelColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(
    String label,
    int value,
    ValueChanged<int>? onChanged,
    bool isEdit,
    Color textColor,
    Color labelColor,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Chivo',
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: labelColor,
          ),
        ),
        const SizedBox(width: 4),
        if (!isEdit)
          Text(
            '${value}g',
            style: TextStyle(
              fontFamily: 'Chivo',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: textColor,
            ),
          )
        else
          SizedBox(
            width: 40,
            child: TextFormField(
              initialValue: value.toString(),
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontFamily: 'Chivo',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: textColor,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixText: 'g',
                border: InputBorder.none,
              ),
              onChanged: (val) {
                final parsed = int.tryParse(val) ?? 0;
                if (onChanged != null) {
                  onChanged(parsed);
                }
              },
            ),
          ),
      ],
    );
  }
}
