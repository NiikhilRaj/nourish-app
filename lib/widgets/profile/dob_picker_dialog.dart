import 'package:flutter/material.dart';

class DobPickerDialog extends StatefulWidget {
  final String initialDob;

  const DobPickerDialog({super.key, required this.initialDob});

  static Future<String?> show(BuildContext context, String initialDob) {
    return showDialog<String>(
      context: context,
      builder: (context) => DobPickerDialog(initialDob: initialDob),
    );
  }

  @override
  State<DobPickerDialog> createState() => _DobPickerDialogState();
}

class _DobPickerDialogState extends State<DobPickerDialog> {
  late int selectedDay;
  late int selectedMonth; // 1-indexed (1 = Jan, 12 = Dec)
  late int selectedYear;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _parseInitialDob();
  }

  void _parseInitialDob() {
    try {
      final parts = widget.initialDob.split('/');
      if (parts.length == 3) {
        selectedDay = int.parse(parts[0]);
        selectedMonth = int.parse(parts[1]);
        selectedYear = int.parse(parts[2]);
      } else {
        selectedDay = 1;
        selectedMonth = 1;
        selectedYear = 2000;
      }
    } catch (_) {
      selectedDay = 1;
      selectedMonth = 1;
      selectedYear = 2000;
    }
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      final isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    final monthsWith30Days = [4, 6, 9, 11];
    if (monthsWith30Days.contains(month)) {
      return 30;
    }
    return 31;
  }

  void _adjustDayIfNeeded() {
    final maxDays = _getDaysInMonth(selectedYear, selectedMonth);
    if (selectedDay > maxDays) {
      setState(() {
        selectedDay = maxDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final dialogBg = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final primaryColor = theme.primaryColor;

    final currentYear = DateTime.now().year;
    final years = List<int>.generate(currentYear - 1900 + 1, (i) => currentYear - i);
    final maxDays = _getDaysInMonth(selectedYear, selectedMonth);
    final days = List<int>.generate(maxDays, (i) => i + 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: dialogBg,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date of Birth',
              style: TextStyle(
                fontFamily: 'Chivo',
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // 1. Date (Day) Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : const Color(0xfff1efef),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedDay,
                            dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                            isExpanded: true,
                            items: days.map((day) {
                              return DropdownMenuItem<int>(
                                value: day,
                                child: Text(
                                  day.toString(),
                                  style: TextStyle(color: textColor, fontFamily: 'Chivo'),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  selectedDay = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 2. Month Dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Month',
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : const Color(0xfff1efef),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedMonth,
                            dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                            isExpanded: true,
                            items: List.generate(12, (i) => i + 1).map((mIndex) {
                              return DropdownMenuItem<int>(
                                value: mIndex,
                                child: Text(
                                  months[mIndex - 1],
                                  style: TextStyle(color: textColor, fontFamily: 'Chivo'),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  selectedMonth = val;
                                });
                                _adjustDayIfNeeded();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 3. Year Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year',
                        style: TextStyle(
                          fontFamily: 'Chivo',
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : const Color(0xfff1efef),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedYear,
                            dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                            isExpanded: true,
                            items: years.map((year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(
                                  year.toString(),
                                  style: TextStyle(color: textColor, fontFamily: 'Chivo'),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  selectedYear = val;
                                });
                                _adjustDayIfNeeded();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final dayStr = selectedDay.toString().padLeft(2, '0');
                    final monthStr = selectedMonth.toString().padLeft(2, '0');
                    final result = '$dayStr/$monthStr/$selectedYear';
                    Navigator.of(context).pop(result);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Set',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      color: Colors.white,
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
