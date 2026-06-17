import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:sqflite/sqflite.dart';
import 'saved_recipes_model.dart';
import '../../backend/daos/saved_recipe_dao.dart';
import '../../providers/db_provider.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/bottom_nav_bar.dart';

class SavedRecipesView extends StatefulWidget {
  const SavedRecipesView({super.key});

  @override
  State<SavedRecipesView> createState() => _SavedRecipesViewState();
}

class _SavedRecipesViewState extends State<SavedRecipesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showRecipeDetails(BuildContext context, Recipe recipe, SavedRecipesViewModel model, Database db) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(
                            fontFamily: 'Chivo',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await model.deleteRecipe(db, recipe.id);
                          toastification.show(
                            context: context,
                            title: const Text('Recipe removed from Saved'),
                            type: ToastificationType.info,
                            style: ToastificationStyle.flat,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Color(0xFF8B80F9),
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.duration,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nutrition Info matching Figma purple container
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EFFF), // Figma purple tint
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFigmaNutritionItem('Calories', '${recipe.calories}', 'kcal'),
                        _buildFigmaNutritionItem('Protein', '${recipe.protein.round()}', 'g'),
                        _buildFigmaNutritionItem('Carbs', '${recipe.carbs.round()}', 'g'),
                        _buildFigmaNutritionItem('Fat', '${recipe.fat.round()}', 'g'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...recipe.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Text('  •  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            ing,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 25),

                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...recipe.instructions.asMap().entries.map((entry) {
                    final idx = entry.key + 1;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B80F9),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$idx',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step,
                              style: const TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFigmaNutritionItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 2),
        Text(
          unit,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dbProvider = Provider.of<DbProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => SavedRecipesViewModel(),
      child: Consumer<SavedRecipesViewModel>(
        builder: (context, model, child) {
          return FutureBuilder<Database>(
            future: dbProvider.db,
            builder: (context, dbSnapshot) {
              if (!dbSnapshot.hasData) {
                return const Scaffold(
                  bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final db = dbSnapshot.data!;
              
              if (model.savedRecipes.isEmpty && _searchController.text.isEmpty && !model.isLoading) {
                Future.microtask(() => model.loadSavedRecipes(db));
              }

              return Scaffold(
                backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
                appBar: AppBar(
                  title: const Text(
                    'Saved Recipes',
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
                body: SafeArea(
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search within saved recipes...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF8B80F9), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (val) => model.search(val),
                        ),
                      ),

                      // List
                      Expanded(
                        child: model.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : model.savedRecipes.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.bookmark_border, size: 48, color: Colors.grey),
                                        const SizedBox(height: 12),
                                        Text(
                                          _searchController.text.isNotEmpty
                                              ? 'No matching saved recipes found'
                                              : 'You haven\'t saved any recipes yet',
                                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    itemCount: model.savedRecipes.length,
                                    itemBuilder: (context, index) {
                                      final recipe = model.savedRecipes[index];
                                      return GestureDetector(
                                        onTap: () => _showRecipeDetails(context, recipe, model, db),
                                        child: Stack(
                                          children: [
                                            RecipeCard(
                                              title: recipe.title,
                                              duration: recipe.duration,
                                              widthFactor: 0.95,
                                              nutritionInfo: Row(
                                                children: [
                                                  Text(
                                                    '${recipe.calories} kcal  •  P: ${recipe.protein.round()}g  C: ${recipe.carbs.round()}g  F: ${recipe.fat.round()}g',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 24,
                                              top: 20,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.favorite,
                                                  color: Color(0xFF8B80F9),
                                                ),
                                                onPressed: () async {
                                                  await model.deleteRecipe(db, recipe.id);
                                                  toastification.show(
                                                    context: context,
                                                    title: const Text('Recipe removed from Saved'),
                                                    type: ToastificationType.info,
                                                    style: ToastificationStyle.flat,
                                                    autoCloseDuration: const Duration(seconds: 2),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
