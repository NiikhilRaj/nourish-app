import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'add_meal_model.dart';

class AddMealView extends StatelessWidget {
  const AddMealView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMealViewModel(),
      child: const _AddMealBody(),
    );
  }
}

class _AddMealBody extends StatefulWidget {
  const _AddMealBody();

  @override
  State<_AddMealBody> createState() => _AddMealBodyState();
}

class _AddMealBodyState extends State<_AddMealBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  String _selectedMealType = 'Breakfast';

  final List<Map<String, dynamic>> _mealTypes = [
    {'label': 'Breakfast', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Lunch', 'icon': Icons.light_mode_outlined},
    {'label': 'Dinner', 'icon': Icons.nightlight_outlined},
    {'label': 'Snack', 'icon': Icons.cookie_outlined},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} added to $_selectedMealType!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      context.go('/food_log');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Add Meal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/food_log'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meal Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Row(
                children:
                    _mealTypes.map((type) {
                      final selected = _selectedMealType == type['label'];
                      return Expanded(
                        child: GestureDetector(
                          onTap:
                              () => setState(
                                () => _selectedMealType = type['label'],
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  type['icon'] as IconData,
                                  color:
                                      selected
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  type['label'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selected
                                            ? Colors.white
                                            : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Food Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Chicken Rice',
                  prefixIcon: const Icon(Icons.restaurant_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.2),
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter food name' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Calories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'kcal',
                  prefixIcon: const Icon(Icons.local_fire_department_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.2),
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter calories' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Macros',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _MacroField(
                      controller: _proteinController,
                      label: 'Protein',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MacroField(
                      controller: _carbsController,
                      label: 'Carbs',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MacroField(
                      controller: _fatsController,
                      label: 'Fats',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Add Meal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;

  const _MacroField({
    required this.controller,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '$label (g)',
        labelStyle: TextStyle(color: color, fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: color.withOpacity(0.08),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}
