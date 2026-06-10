import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditMode;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final List<String>? dropdownOptions;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final VoidCallback? onTap;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.isEditMode = false,
    this.onChanged,
    this.controller,
    this.dropdownOptions,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tileColor = isDark ? Colors.grey[850] : const Color(0xfff1efef);
    final textColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const SizedBox(width: 16),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: !isEditMode
                    ? Text(
                        value.isEmpty ? 'Not Set' : value,
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: textColor,
                        ),
                      )
                    : onTap != null
                        ? GestureDetector(
                            onTap: onTap,
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  value.isEmpty ? 'Tap to Set' : value,
                                  style: TextStyle(
                                    fontFamily: 'Chivo',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                                if (suffixIcon != null) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    suffixIcon,
                                    size: 16,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ],
                              ],
                            ),
                          )
                        : dropdownOptions != null
                            ? DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: dropdownOptions!.contains(value) ? value : dropdownOptions!.first,
                                  alignment: Alignment.centerRight,
                                  dropdownColor: tileColor,
                                  isDense: true,
                                  style: TextStyle(
                                    fontFamily: 'Chivo',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                  items: dropdownOptions!.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(option),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null && onChanged != null) {
                                      onChanged!(val);
                                    }
                                  },
                                ),
                              )
                            : TextFormField(
                                controller: controller ?? TextEditingController(text: value),
                                keyboardType: keyboardType,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontFamily: 'Chivo',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                                onChanged: onChanged,
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
