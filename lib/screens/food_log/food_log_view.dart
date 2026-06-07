import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'food_log_model.dart';

class FoodLogView extends StatelessWidget {
  const FoodLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodLogViewModel(),
      child: const _FoodLogBody(),
    );
  }
}

class _FoodLogBody extends StatefulWidget {
  const _FoodLogBody();

  @override
  State<_FoodLogBody> createState() => _FoodLogBodyState();
}

class _FoodLogBodyState extends State<_FoodLogBody> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, Map<String, List<Map<String, dynamic>>>> _allMeals = {
    DateTime.utc(2026, 6, 7): {
      'Breakfast': [
        {'name': 'Eggs', 'cal': 140, 'protein': 12, 'carbs': 1, 'fats': 10},
      ],
      'Lunch': [
        {'name': 'Salad', 'cal': 90, 'protein': 3, 'carbs': 12, 'fats': 4},
      ],
      'Dinner': [
        {
          'name': 'Protein Shake',
          'cal': 180,
          'protein': 25,
          'carbs': 10,
          'fats': 3,
        },
      ],
      'Snack': [],
    },
    DateTime.utc(2026, 6, 6): {
      'Breakfast': [
        {
          'name': 'Banana Smoothie',
          'cal': 200,
          'protein': 4,
          'carbs': 42,
          'fats': 2,
        },
      ],
      'Lunch': [
        {
          'name': 'Dal Chawal',
          'cal': 380,
          'protein': 14,
          'carbs': 65,
          'fats': 6,
        },
      ],
      'Dinner': [],
      'Snack': [],
    },
  };

  static const List<String> _mealOrder = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];
  static const Map<String, IconData> _mealIcons = {
    'Breakfast': Icons.wb_sunny_outlined,
    'Lunch': Icons.light_mode_outlined,
    'Dinner': Icons.nightlight_outlined,
    'Snack': Icons.cookie_outlined,
  };

  Map<String, List<Map<String, dynamic>>> _getMealsForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return _allMeals[key] ??
        {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Snack': []};
  }

  List<Map<String, dynamic>> _flatList(DateTime day) {
    final data = _getMealsForDay(day);
    return data.values.expand((e) => e).toList();
  }

  int _totalCalories(DateTime day) {
    return _flatList(day).fold(0, (sum, m) => sum + (m['cal'] as int));
  }

  void _showMealDetail(BuildContext context, Map<String, dynamic> meal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        meal['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${meal['cal']} kcal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MacroTile('Protein', '${meal['protein']}g', Colors.blue),
                    _MacroTile('Carbs', '${meal['carbs']}g', Colors.orange),
                    _MacroTile('Fats', '${meal['fats']}g', Colors.red),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayMeals = _getMealsForDay(_selectedDay);
    final total = _totalCalories(_selectedDay);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Food Log',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) => _flatList(day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$total kcal',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children:
                  _mealOrder.map((mealType) {
                    final items = dayMeals[mealType] ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                _mealIcons[mealType],
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                mealType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${items.fold(0, (s, m) => s + (m['cal'] as int))} kcal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (items.isEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.5),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'No $mealType logged',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...items.map(
                            (meal) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                  child: Icon(
                                    _mealIcons[mealType],
                                    size: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  meal['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text('${meal['cal']} kcal'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _showMealDetail(context, meal),
                              ),
                            ),
                          ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add_meal'),
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroTile(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
