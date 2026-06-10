import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HorizontalGenderPicker extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const HorizontalGenderPicker({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final maleColor = const Color(0xff6F60EF);
    final femaleColor = const Color(0xffF44336);
    final othersColor = const Color(0xff9C27B0);

    final options = [
      {
        'label': 'Male',
        'icon': FontAwesomeIcons.mars,
        'color': maleColor,
      },
      {
        'label': 'Female',
        'icon': FontAwesomeIcons.venus,
        'color': femaleColor,
      },
      {
        'label': 'Others',
        'icon': FontAwesomeIcons.transgender,
        'color': othersColor,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((opt) {
        final label = opt['label'] as String;
        final icon = opt['icon'] as IconData;
        final color = opt['color'] as Color;

        final isSelected = selectedGender.toLowerCase() == label.toLowerCase() ||
            (label == 'Others' && selectedGender.toLowerCase() == 'other');

        final bg = isSelected
            ? color
            : (isDark ? Colors.grey[850]! : const Color(0xfff1efef));

        final contentColor = isSelected
            ? Colors.white
            : (isDark ? Colors.grey[400]! : Colors.grey[600]!);

        return Expanded(
          child: GestureDetector(
            onTap: () {
              onChanged(label == 'Others' ? 'Other' : label);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              height: 110,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                          width: 1.5,
                        ),
                        color: isSelected ? Colors.white : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 12,
                              color: color,
                            )
                          : null,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        FaIcon(
                          icon,
                          size: 32,
                          color: contentColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Chivo',
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                            fontSize: 14,
                            color: contentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
