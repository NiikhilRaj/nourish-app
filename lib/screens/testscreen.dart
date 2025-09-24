
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/recipe.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Box<Recipe> recipeBox;

  @override
  void initState() {
    super.initState();
    recipeBox = Hive.box<Recipe>('recipesBox');
  }

  void _addDummyRecipe() {
    final newRecipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Dummy recipe ${recipeBox.length + 1}',
      description: 'This is a description for recipe ${recipeBox.length + 1}',
    );
    recipeBox.add(newRecipe);
    
  }

  void _updateFirstRecipe() {
    if (recipeBox.isEmpty) return;
    final recipe = recipeBox.getAt(0);
    if (recipe != null) {
      recipe.title = recipe.title + ' (edited)';
      recipe.save(); 
    }
  }

  void _deleteFirstRecipe() {
    if (recipeBox.isEmpty) return;
    recipeBox.deleteAt(0);
  }

  void _clearAll() {
    recipeBox.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Test Screen'),
        actions: [
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _addDummyRecipe,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                ElevatedButton.icon(
                  onPressed: _updateFirstRecipe,
                  icon: const Icon(Icons.edit),
                  label: const Text('Update first'),
                ),
                ElevatedButton.icon(
                  onPressed: _deleteFirstRecipe,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete first'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: recipeBox.listenable(),
              builder: (context, Box<Recipe> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No recipes yet.'));
                }
                return ListView.separated(
                  itemCount: box.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final recipe = box.getAt(index);
                    return ListTile(
                      title: Text(recipe?.title ?? 'No title'),
                      subtitle: Text(recipe?.description ?? ''),
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              if (recipe == null) return;
                              recipe.title = recipe.title + ' (test)';
                              recipe.save();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              recipe?.delete(); 
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
