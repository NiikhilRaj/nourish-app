import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../backend/open_food_facts_service.dart';
import '../../backend/daos/saved_recipe_dao.dart';

class AiRecipesViewModel extends ChangeNotifier {
  bool _isSearching = false;
  bool _isGenerating = false;
  List<FoodProduct> _searchResults = [];
  final List<FoodProduct> _selectedIngredients = [];
  List<Recipe> _generatedRecipes = [];
  String _selectedCookingStyle = 'Stir Fry';
  String _selectedMealType = 'Lunch';
  String _errorMessage = '';

  bool get isSearching => _isSearching;
  bool get isGenerating => _isGenerating;
  List<FoodProduct> get searchResults => _searchResults;
  List<FoodProduct> get selectedIngredients => _selectedIngredients;
  List<Recipe> get generatedRecipes => _generatedRecipes;
  String get selectedCookingStyle => _selectedCookingStyle;
  String get selectedMealType => _selectedMealType;
  String get errorMessage => _errorMessage;

  void setCookingStyle(String style) {
    _selectedCookingStyle = style;
    notifyListeners();
  }

  void setMealType(String type) {
    _selectedMealType = type;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _errorMessage = '';
    notifyListeners();
  }

  List<FoodProduct> _getLocalSuggestions(String query) {
    final common = [
      'Paneer', 'Coriander', 'Onion', 'Turmeric', 'Tomato', 'Garlic', 'Ginger', 
      'Chicken', 'Rice', 'Spinach', 'Potato', 'Milk', 'Cheese', 'Butter', 'Egg', 'Flour', 'Maggi'
    ];
    final normalizedQuery = query.toLowerCase().trim();
    final matches = common.where((ing) => ing.toLowerCase().contains(normalizedQuery)).toList();
    
    if (matches.isEmpty) {
      matches.add(query[0].toUpperCase() + query.substring(1));
    }
    
    return matches.map((name) => FoodProduct(
      code: 'local_${name.toLowerCase()}',
      name: name,
      imageUrl: '',
      ingredients: '',
      calories: 90.0,
      protein: 4.0,
      carbs: 12.0,
      fat: 3.0,
    )).toList();
  }

  Future<void> searchIngredients(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await OpenFoodFactsService.searchProducts(query);
      if (results.isEmpty) {
        _searchResults = _getLocalSuggestions(query);
      } else {
        _searchResults = results;
      }
    } catch (e) {
      _searchResults = _getLocalSuggestions(query);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void addIngredient(FoodProduct product) {
    if (!_selectedIngredients.any((p) => p.name.toLowerCase() == product.name.toLowerCase())) {
      _selectedIngredients.add(product);
      notifyListeners();
    }
  }

  void addIngredientByName(String name) {
    if (name.trim().isEmpty) return;
    final cleanName = name.trim();
    if (!_selectedIngredients.any((p) => p.name.toLowerCase() == cleanName.toLowerCase())) {
      _selectedIngredients.add(FoodProduct(
        code: 'manual_${Random().nextInt(100000)}',
        name: cleanName,
        imageUrl: '',
        ingredients: '',
        calories: 80.0,
        protein: 3.0,
        carbs: 15.0,
        fat: 2.0,
      ));
      notifyListeners();
    }
  }

  void removeIngredient(FoodProduct product) {
    _selectedIngredients.removeWhere((p) => p.code == product.code);
    notifyListeners();
  }

  void clearIngredients() {
    _selectedIngredients.clear();
    notifyListeners();
  }

  Future<void> generateRecipe() async {
    if (_selectedIngredients.isEmpty) {
      _errorMessage = 'Please add at least one ingredient.';
      notifyListeners();
      return;
    }

    _isGenerating = true;
    _errorMessage = '';
    _generatedRecipes = [];
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final selectedIngNames = _selectedIngredients.map((e) => e.name).toList();
      final mainIng = selectedIngNames.isNotEmpty ? selectedIngNames[0] : 'Fresh Veggies';

      final list = _getSpecializedRecipes(mainIng, selectedIngNames, _selectedMealType, _selectedCookingStyle);

      list.sort((a, b) {
        final style = _selectedCookingStyle.toLowerCase();
        final aMatches = _doesRecipeMatchStyle(a.id, style);
        final bMatches = _doesRecipeMatchStyle(b.id, style);
        if (aMatches && !bMatches) return -1;
        if (!aMatches && bMatches) return 1;
        return 0;
      });

      _generatedRecipes = list;
    } catch (e) {
      _errorMessage = 'Failed to generate recipe.';
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  bool _doesRecipeMatchStyle(String id, String style) {
    final cleanStyle = style.replaceAll(' ', '').toLowerCase();
    return id.contains(cleanStyle);
  }

  List<Recipe> _getSpecializedRecipes(String mainIng, List<String> ingredientNames, String mealType, String cookingStyle) {
    final list = <Recipe>[];
    final mainLower = mainIng.toLowerCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (mainLower.contains('maggi')) {
      list.add(Recipe(
        id: 'maggi_stirfry_1_$timestamp',
        title: "Classic Street Style Masala Maggi",
        duration: "10 mins",
        ingredients: ["Maggi Noodles 1 pack", "Tastemaker 1 pack", "Onion 1/2 (chopped)", "Tomato 1/2 (chopped)", "Green Peas 20g", "Butter 10g"],
        instructions: [
          "DO this: Heat butter in a pan. Sauté chopped onions and green chilies for 2 minutes.",
          "Do that: Add chopped tomatoes, green peas, and tastemaker. Cook for 1 minute.",
          "fry this: Pour in 1.5 cups of water and bring to a boil. Break Maggi noodles and add to the pan.",
          "stir that: Cook on medium-high heat for 3-4 minutes until water is absorbed and noodles are soft. Serve hot."
        ],
        calories: 320, protein: 8.0, carbs: 48.0, fat: 12.0,
      ));
      list.add(Recipe(
        id: 'maggi_baked_$timestamp',
        title: "Cheesy Garlic Baked Maggi",
        duration: "15 mins",
        ingredients: ["Maggi Noodles 1 pack", "Tastemaker 1 pack", "Minced Garlic 4 cloves", "Butter 15g", "Grated Cheese 30g"],
        instructions: [
          "DO this: Boil Maggi noodles in plain water for 2 minutes until 80% cooked, then drain.",
          "Do that: Sauté minced garlic in melted butter until fragrant. Mix with the drained noodles and tastemaker.",
          "fry this: Place the garlic noodles in a baking dish and cover generously with grated cheese.",
          "stir that: Bake at 180°C for 6-8 minutes until the cheese is melted, bubbling, and golden brown. Serve hot."
        ],
        calories: 420, protein: 12.0, carbs: 50.0, fat: 18.0,
      ));
      list.add(Recipe(
        id: 'maggi_sauteed_$timestamp',
        title: "Spicy Maggi Egg/Paneer Bhurji Mix",
        duration: "12 mins",
        ingredients: ["Maggi Noodles 1 pack", "Tastemaker 1 pack", "Eggs 2 (or Paneer 100g crumbled)", "Onion 1/2 (chopped)", "Oil 1 tbsp"],
        instructions: [
          "DO this: Boil Maggi in 1.5 cups of water with the tastemaker until fully cooked, then set aside.",
          "Do that: In another pan, heat oil and sauté chopped onions. Add eggs (or crumbled paneer) and scramble with salt.",
          "fry this: Once the scramble (bhurji) is cooked, add the prepared Maggi noodles directly into the pan.",
          "stir that: Toss everything together on high heat for 2 minutes to blend the flavors. Garnish with herbs and serve."
        ],
        calories: 380, protein: 15.0, carbs: 44.0, fat: 16.0,
      ));
      list.add(Recipe(
        id: 'maggi_stirfry_2_$timestamp',
        title: "Chinese Chili Garlic Maggi",
        duration: "10 mins",
        ingredients: ["Maggi Noodles 1 pack", "Tastemaker 1/2 pack", "Soy Sauce 1 tsp", "Chili Sauce 1 tsp", "Garlic 4 cloves (sliced)", "Oil 1 tbsp"],
        instructions: [
          "DO this: Boil Maggi noodles for 2 minutes, drain, and rinse with cold water to prevent sticking.",
          "Do that: Heat oil in a wok. Fry sliced garlic and dry red chilies on high heat for 1 minute.",
          "fry this: Add boiled noodles, soy sauce, chili sauce, and half of the tastemaker.",
          "stir that: Toss quickly on high heat for 2 minutes. Garnish with spring onion greens and serve hot."
        ],
        calories: 310, protein: 7.5, carbs: 46.0, fat: 11.5,
      ));
      list.add(Recipe(
        id: 'maggi_fried_$timestamp',
        title: "Crispy Fried Maggi Pakoras",
        duration: "18 mins",
        ingredients: ["Maggi Noodles 1 pack", "Tastemaker 1 pack", "Gram Flour (Besan) 3 tbsp", "Onion 1/2 (sliced)", "Oil for deep frying"],
        instructions: [
          "DO this: Boil Maggi in water with tastemaker until fully cooked. Let it cool down completely.",
          "Do that: Mix the cooled noodles with gram flour, sliced onions, chopped coriander, and a pinch of salt.",
          "fry this: Shape the mixture into small bite-sized round pakoras.",
          "stir that: Slide them into hot oil and deep fry on medium heat for 4-5 minutes until golden and crispy. Serve with chutney."
        ],
        calories: 360, protein: 9.0, carbs: 52.0, fat: 14.0,
      ));
    } else if (mainLower.contains('paneer')) {
      list.add(Recipe(
        id: 'paneer_stirfry_$timestamp',
        title: "Crispy Paneer Tawa Stir Fry",
        duration: "15 mins",
        ingredients: ["Paneer 150g (cubes)", "Onion 1 (sliced)", "Capsicum 1/2 (sliced)", "Soy Sauce 1 tsp", "Butter 10g"],
        instructions: [
          "DO this: Slice paneer, onion, and capsicum. Heat butter in a flat frying pan.",
          "Do that: Toss in paneer cubes and sauté for 3 minutes until lightly golden. Set aside.",
          "fry this: Sauté onions and capsicum on high heat in the same pan for 3 minutes.",
          "stir that: Return paneer to the pan, add soy sauce, salt, and pepper. Toss for 2 minutes."
        ],
        calories: 290, protein: 17.0, carbs: 5.5, fat: 22.0,
      ));
      list.add(Recipe(
        id: 'paneer_curry_$timestamp',
        title: "Dhaba Style Paneer Masala Curry",
        duration: "25 mins",
        ingredients: ["Paneer 150g (cubes)", "Onions 2 (chopped)", "Tomatoes 2 (puréed)", "Ginger-Garlic Paste 1 tsp", "Garam Masala 1/2 tsp"],
        instructions: [
          "DO this: Heat oil, sauté chopped onions until golden. Add ginger-garlic paste.",
          "Do that: Pour in tomatoes, turmeric, salt, and chili powder. Cook until oil separates.",
          "fry this: Add paneer cubes and half a cup of warm water. Simmer covered for 8 minutes.",
          "stir that: Sprinkle garam masala, garnish with fresh coriander, and serve hot."
        ],
        calories: 360, protein: 16.5, carbs: 12.0, fat: 26.0,
      ));
      list.add(Recipe(
        id: 'paneer_baked_$timestamp',
        title: "Tandoori Grilled Paneer Tikka",
        duration: "20 mins",
        ingredients: ["Paneer 150g (cubes)", "Yogurt 3 tbsp", "Ginger-Garlic Paste 1 tsp", "Lemon Juice 1 tsp"],
        instructions: [
          "DO this: Mix yogurt, ginger-garlic paste, spices, and lemon juice to make a marinade.",
          "Do that: Coat paneer cubes in the marinade and let rest for 10 minutes.",
          "fry this: Arrange paneer on a baking tray lined with greaseproof paper.",
          "stir that: Bake at 200°C for 12 minutes until charred on the edges. Serve hot."
        ],
        calories: 280, protein: 18.0, carbs: 6.5, fat: 19.0,
      ));
      list.add(Recipe(
        id: 'paneer_sauteed_$timestamp',
        title: "Spiced Paneer Bhurji Toast",
        duration: "10 mins",
        ingredients: ["Paneer 100g (crumbled)", "Bread 2 slices", "Onion 1/2 (chopped)", "Turmeric 1/4 tsp", "Butter 10g"],
        instructions: [
          "DO this: Melt butter in a pan. Sauté chopped onions and green chili until soft.",
          "Do that: Add turmeric powder, salt, and crumbled paneer. Cook for 3 minutes.",
          "fry this: Toast the bread slices in a toaster or on a pan until golden brown.",
          "stir that: Spread the hot paneer bhurji evenly over the toasted bread and serve."
        ],
        calories: 220, protein: 14.5, carbs: 6.0, fat: 16.0,
      ));
      list.add(Recipe(
        id: 'paneer_fried_$timestamp',
        title: "Golden Fried Paneer Pakoras",
        duration: "18 mins",
        ingredients: ["Paneer 150g (sliced)", "Gram Flour (Besan) 4 tbsp", "Turmeric 1/4 tsp", "Oil for frying"],
        instructions: [
          "DO this: Mix gram flour, salt, turmeric, and water to make a smooth thick batter.",
          "Do that: Dip paneer slices in the batter until completely coated.",
          "fry this: Deep fry in hot oil on medium heat for 4 minutes.",
          "stir that: Fry until crispy and golden brown. Serve hot with green chutney."
        ],
        calories: 340, protein: 15.0, carbs: 18.0, fat: 24.0,
      ));
    } else if (mainLower.contains('egg')) {
      list.add(Recipe(
        id: 'egg_stirfry_$timestamp',
        title: "Classic Masala Egg Bhurji",
        duration: "10 mins",
        ingredients: ["Eggs 2", "Onion 1/2 (chopped)", "Tomato 1/2 (chopped)", "Butter 10g", "Coriander 5g"],
        instructions: [
          "DO this: Whisk the eggs with a pinch of salt and black pepper in a small bowl.",
          "Do that: Sauté chopped onions and green chilies in melted butter.",
          "fry this: Add chopped tomatoes, then pour in the whisked eggs.",
          "stir that: Scramble continuously on medium heat for 3 minutes. Garnish with coriander and serve."
        ],
        calories: 210, protein: 13.5, carbs: 5.0, fat: 15.0,
      ));
      list.add(Recipe(
        id: 'egg_baked_$timestamp',
        title: "Cheese & Onion Baked Omelette",
        duration: "8 mins",
        ingredients: ["Eggs 2", "Onion 1/2 (chopped)", "Grated Cheese 20g", "Butter 10g"],
        instructions: [
          "DO this: Whisk eggs with chopped onions, salt, pepper, and a splash of milk.",
          "Do that: Pour into a greased small oven-safe dish and sprinkle cheese on top.",
          "fry this: Bake at 180°C for 10 minutes until puffed up and cheese is melted.",
          "stir that: Garnish with fresh herbs and serve immediately while hot."
        ],
        calories: 195, protein: 13.0, carbs: 3.5, fat: 14.5,
      ));
      list.add(Recipe(
        id: 'egg_curry_$timestamp',
        title: "Spicy Dhaba Egg Curry",
        duration: "22 mins",
        ingredients: ["Boiled Eggs 2 (halved)", "Onion 1 (chopped)", "Tomato 1 (pureed)", "Turmeric 1/2 tsp", "Oil 1 tbsp"],
        instructions: [
          "DO this: Sauté chopped onions and ginger-garlic paste in hot oil.",
          "Do that: Pour in tomatoes, turmeric, salt, and curry powder. Cook for 5 minutes.",
          "fry this: Add boiled egg halves gently, spooning the curry base over them.",
          "stir that: Cover and simmer on low heat for 5 minutes. Serve with hot rotis."
        ],
        calories: 260, protein: 14.0, carbs: 7.5, fat: 19.0,
      ));
      list.add(Recipe(
        id: 'egg_sauteed_$timestamp',
        title: "Boiled Egg Sauté Salad",
        duration: "8 mins",
        ingredients: ["Boiled Eggs 2 (sliced)", "Onion 1/2 (sliced)", "Butter 10g", "Turmeric 1/4 tsp"],
        instructions: [
          "DO this: Melt butter in a wide frying pan over medium heat.",
          "Do that: Sauté sliced onions and turmeric for 3 minutes until soft.",
          "fry this: Gently place the boiled egg slices in the pan.",
          "stir that: Season with salt and pepper. Toss gently for 2 minutes and serve warm."
        ],
        calories: 180, protein: 13.0, carbs: 4.0, fat: 13.0,
      ));
      list.add(Recipe(
        id: 'egg_fried_$timestamp',
        title: "Golden Fried Egg Bonda",
        duration: "12 mins",
        ingredients: ["Boiled Eggs 2 (halved)", "Besan (Gram Flour) 4 tbsp", "Turmeric 1/4 tsp", "Oil for frying"],
        instructions: [
          "DO this: Whisk gram flour, salt, turmeric, and water to make a thick batter.",
          "Do that: Dip halved boiled eggs in the batter to coat them completely.",
          "fry this: Carefully slide them into hot oil and fry on medium-high heat.",
          "stir that: Fry for 4 minutes until golden and crispy. Drain and serve hot."
        ],
        calories: 230, protein: 12.0, carbs: 14.0, fat: 15.0,
      ));
    } else if (mainLower.contains('chicken')) {
      list.add(Recipe(
        id: 'chicken_stirfry_$timestamp',
        title: "Ginger Garlic Chicken Stir Fry",
        duration: "18 mins",
        ingredients: ["Chicken Breast 200g (cubes)", "Onion 1 (sliced)", "Ginger-Garlic Paste 1 tsp", "Oil 1 tbsp"],
        instructions: [
          "DO this: Heat oil in a wok. Sauté sliced onions and ginger-garlic paste.",
          "Do that: Add chicken cubes and stir-fry on high heat for 6 minutes.",
          "fry this: Reduce heat, add pepper and salt, and cook for 8 more minutes.",
          "stir that: Squeeze fresh lemon juice on top. Serve hot."
        ],
        calories: 310, protein: 31.5, carbs: 5.0, fat: 15.0,
      ));
      list.add(Recipe(
        id: 'chicken_curry_$timestamp',
        title: "Homestyle Chicken Curry Masala",
        duration: "30 mins",
        ingredients: ["Chicken 200g", "Onions 2 (chopped)", "Tomato 1 (chopped)", "Turmeric 1/2 tsp", "Oil 2 tbsp"],
        instructions: [
          "DO this: Heat oil, brown the chicken pieces for 5 minutes, then remove.",
          "Do that: Sauté chopped onions until golden. Add tomatoes, turmeric, and spices.",
          "fry this: Return chicken, pour in 1 cup of water, and simmer covered for 15 minutes.",
          "stir that: Let the gravy thicken, garnish with fresh coriander, and serve."
        ],
        calories: 410, protein: 32.0, carbs: 8.0, fat: 22.0,
      ));
      list.add(Recipe(
        id: 'chicken_sauteed_$timestamp',
        title: "Garlic Butter Grilled Chicken",
        duration: "20 mins",
        ingredients: ["Chicken Breast 200g", "Garlic 4 cloves (minced)", "Butter 15g", "Lemon Juice 1 tsp"],
        instructions: [
          "DO this: Season chicken breast with salt, pepper, and minced garlic.",
          "Do that: Melt butter in a pan. Place the chicken breast in the middle.",
          "fry this: Cook on medium-high heat for 6 minutes on each side until cooked through.",
          "stir that: Drizzle lemon juice and let rest for 2 minutes before slicing."
        ],
        calories: 330, protein: 34.0, carbs: 2.0, fat: 16.0,
      ));
      list.add(Recipe(
        id: 'chicken_baked_$timestamp',
        title: "Oven Baked Chicken Tikka",
        duration: "20 mins",
        ingredients: ["Chicken 200g (cubes)", "Yogurt 3 tbsp", "Ginger-Garlic Paste 1 tsp", "Lemon Juice 1 tsp"],
        instructions: [
          "DO this: Mix yogurt, spices, ginger-garlic paste, and lemon juice in a bowl.",
          "Do that: Toss chicken cubes in the marinade and let rest for 10 minutes.",
          "fry this: Arrange on a greased baking tray and bake at 200°C for 15 minutes.",
          "stir that: Turn once to get char marks. Garnish with coriander and serve hot."
        ],
        calories: 290, protein: 32.0, carbs: 5.0, fat: 13.0,
      ));
      list.add(Recipe(
        id: 'chicken_fried_$timestamp',
        title: "Crispy Fried Chicken Pakora",
        duration: "15 mins",
        ingredients: ["Chicken 200g (small cubes)", "Besan (Gram Flour) 3 tbsp", "Spices 1 tsp", "Oil for frying"],
        instructions: [
          "DO this: Mix chicken cubes, gram flour, spices, salt, and a splash of water.",
          "Do that: Ensure chicken pieces are coated in a thick batter layer.",
          "fry this: Slide pieces individually into hot oil and fry on medium heat.",
          "stir that: Fry for 6-8 minutes until golden and cooked through. Serve hot."
        ],
        calories: 350, protein: 32.0, carbs: 10.0, fat: 18.0,
      ));
    } else if (mainLower.contains('potato') || mainLower.contains('aloo')) {
      list.add(Recipe(
        id: 'potato_stirfry_$timestamp',
        title: "Bombay Spiced Aloo Stir Fry",
        duration: "18 mins",
        ingredients: ["Potatoes 2 (cubed)", "Onion 1 (sliced)", "Turmeric 1/2 tsp", "Cumin 1 tsp", "Oil 1 tbsp"],
        instructions: [
          "DO this: Parboil potato cubes for 5 minutes in salted water, then drain.",
          "Do that: Heat oil, splutter cumin seeds, and sauté sliced onions.",
          "fry this: Add potatoes, turmeric, salt, and spices. Pan-fry on medium heat.",
          "stir that: Sauté for 10 minutes until potatoes are golden and crispy. Serve hot."
        ],
        calories: 195, protein: 3.5, carbs: 36.0, fat: 4.5,
      ));
      list.add(Recipe(
        id: 'potato_curry_$timestamp',
        title: "Dhaba Style Aloo Rassa Curry",
        duration: "20 mins",
        ingredients: ["Potatoes 2 (cubed)", "Onion 1 (chopped)", "Tomato 1 (chopped)", "Turmeric 1/2 tsp", "Oil 1 tbsp"],
        instructions: [
          "DO this: Heat oil, sauté chopped onions until soft. Add tomato and spices.",
          "Do that: Add potato cubes and sauté for 2 minutes. Pour in 1 cup of water.",
          "fry this: Cover and cook on medium-low heat for 12 minutes until potatoes are soft.",
          "stir that: Mash a few potato pieces to thicken the gravy. Garnish and serve."
        ],
        calories: 230, protein: 4.0, carbs: 42.0, fat: 5.5,
      ));
      list.add(Recipe(
        id: 'potato_sauteed_$timestamp',
        title: "Creamy Garlic Mashed Potato",
        duration: "15 mins",
        ingredients: ["Potatoes 2", "Butter 15g", "Garlic Paste 1/2 tsp", "Milk 2 tbsp"],
        instructions: [
          "DO this: Boil potatoes until completely tender. Drain and mash well.",
          "Do that: Warm the butter, garlic paste, and milk in a small saucepan.",
          "fry this: Pour the warm mixture into mashed potatoes and whip with a fork.",
          "stir that: Season with salt and pepper. Serve warm as a creamy side."
        ],
        calories: 210, protein: 3.0, carbs: 38.0, fat: 9.0,
      ));
      list.add(Recipe(
        id: 'potato_baked_$timestamp',
        title: "Baked Herb Potato Wedges",
        duration: "20 mins",
        ingredients: ["Potatoes 2 (cut into wedges)", "Oil 1 tbsp", "Garlic Powder 1/2 tsp", "Mixed Herbs 1 tsp"],
        instructions: [
          "DO this: Wash potato wedges and pat dry with a clean cloth.",
          "Do that: Toss wedges with oil, garlic powder, mixed herbs, and salt.",
          "fry this: Arrange in a single layer on a baking tray.",
          "stir that: Bake at 200°C for 20 minutes, turning once, until crispy. Serve hot."
        ],
        calories: 185, protein: 3.0, carbs: 34.0, fat: 4.0,
      ));
      list.add(Recipe(
        id: 'potato_fried_$timestamp',
        title: "Crispy Golden Potato Pakoras",
        duration: "15 mins",
        ingredients: ["Potato 1 (thinly sliced)", "Gram Flour (Besan) 4 tbsp", "Turmeric 1/4 tsp", "Oil for frying"],
        instructions: [
          "DO this: Whisk gram flour, salt, turmeric, and water to make a smooth thick batter.",
          "Do that: Dip the potato slices in batter until fully coated.",
          "fry this: Deep fry in hot oil on medium-high heat.",
          "stir that: Fry for 4-5 minutes, turning occasionally, until golden and crispy. Serve hot."
        ],
        calories: 280, protein: 5.5, carbs: 32.0, fat: 14.0,
      ));
    } else {
      final secondIng = ingredientNames.length > 1 ? ingredientNames[1] : 'Spices';
      final mainLower = mainIng.toLowerCase();
      final isNoodleOrPasta = mainLower.contains('maggi') || 
                              mainLower.contains('noodle') || 
                              mainLower.contains('pasta') || 
                              mainLower.contains('rice');

      list.add(Recipe(
        id: 'dynamic_stirfry_$timestamp',
        title: "Tossed $mainIng & $secondIng Stir Fry",
        duration: "12 mins",
        ingredients: ["$mainIng 150g", if (ingredientNames.length > 1) "$secondIng 50g", "Fresh Herbs 5g", "Cooking Oil 1 tbsp", "Salt & Spices"],
        instructions: [
          isNoodleOrPasta 
              ? "DO this: Boil the $mainIng and drain. Chop your secondary veggies."
              : "DO this: Chop the $mainIng into bite-sized pieces and prep your vegetables.",
          "Do that: Heat 1 tbsp oil in a frying pan and add minced ginger and garlic.",
          "fry this: Toss in $mainIng and stir-fry on high heat for 6 minutes until tender-crisp.",
          "stir that: Season with salt, fresh black pepper, and herbs. Serve hot."
        ],
        calories: 210, protein: 5.0, carbs: 24.0, fat: 9.0,
      ));
      list.add(Recipe(
        id: 'dynamic_curry_$timestamp',
        title: "Homestyle $mainIng Curry Masala",
        duration: "20 mins",
        ingredients: ["$mainIng 150g", if (ingredientNames.length > 1) "$secondIng 50g", "Tomato Puree 3 tbsp", "Cooking Oil 1 tbsp", "Salt & Spices"],
        instructions: [
          isNoodleOrPasta
              ? "DO this: Dice $secondIng. Prepare an aromatic spiced broth in a pot."
              : "DO this: Dice $mainIng. Puree tomatoes and chop onions to prepare the base.",
          "Do that: Sauté onions and ginger-garlic paste in a deep pot until golden brown.",
          "fry this: Add pureed tomatoes, spices, and $mainIng. Simmer for 8 minutes.",
          "stir that: Pour in 1/2 cup warm water, cover and cook until done. Garnish and serve."
        ],
        calories: 240, protein: 4.5, carbs: 26.0, fat: 11.0,
      ));
      list.add(Recipe(
        id: 'dynamic_sauteed_$timestamp',
        title: "Garlic Butter Sautéed $mainIng",
        duration: "10 mins",
        ingredients: ["$mainIng 150g", "Butter 15g", "Minced Garlic 4 cloves", "Fresh Parsley 5g"],
        instructions: [
          isNoodleOrPasta
              ? "DO this: Boil $mainIng until al-dente, drain and toss in cold water."
              : "DO this: Slice the $mainIng thinly. Heat butter in a wide skillet.",
          "Do that: Add minced garlic and sauté for 1 minute until fragrant.",
          "fry this: Add the $mainIng slices/broth. Cook on medium heat for 4 minutes, tossing regularly.",
          "stir that: Season with a pinch of salt, herbs, and lemon juice. Serve warm."
        ],
        calories: 190, protein: 4.0, carbs: 12.0, fat: 14.0,
      ));
      list.add(Recipe(
        id: 'dynamic_baked_$timestamp',
        title: "Oven Baked Spiced $mainIng Platter",
        duration: "18 mins",
        ingredients: ["$mainIng 150g", "Olive Oil 1 tbsp", "Mixed Herbs 1 tsp", "Salt & Pepper"],
        instructions: [
          "DO this: Pre-heat your oven to 190°C (375°F) and grease a baking tray.",
          isNoodleOrPasta
              ? "Do that: Layer the boiled $mainIng with cheese, sauce, and $secondIng in a baking dish."
              : "Do that: Toss $mainIng with olive oil, salt, pepper, and spices.",
          "fry this: Bake the mixture for 12-15 minutes until the top is bubbling and golden.",
          "stir that: Let cool slightly, garnish with fresh herbs, and serve warm."
        ],
        calories: 180, protein: 3.5, carbs: 22.0, fat: 8.0,
      ));
      list.add(Recipe(
        id: 'dynamic_fried_$timestamp',
        title: "Crispy Fried $mainIng Fritters",
        duration: "15 mins",
        ingredients: ["$mainIng 150g", "Gram Flour 4 tbsp", "Turmeric 1/4 tsp", "Oil for frying"],
        instructions: [
          isNoodleOrPasta
              ? "DO this: Mix boiled $mainIng, chopped onion, flour, and spices to form a thick mixture."
              : "DO this: Slice $mainIng into thin rounds. Prepare a light chickpea batter.",
          isNoodleOrPasta
              ? "Do that: Shape the mixture into small cutlets or balls."
              : "Do that: Dip the pieces in the spiced batter until evenly coated.",
          "fry this: Fry in hot oil for 3-4 minutes on each side until golden and crispy.",
          "stir that: Drain excess oil on paper towels. Serve hot with green chutney."
        ],
        calories: 270, protein: 6.0, carbs: 30.0, fat: 12.0,
      ));
    }

    return list;
  }

  Future<FoodProduct?> lookupBarcode(String barcode) async {
    try {
      final product = await OpenFoodFactsService.getProductByBarcode(barcode);
      if (product != null) {
        return product;
      }
    } catch (e) {
      print('Barcode lookup error: $e');
    }
    return null;
  }
}

class PoolRecipe {
  final String title;
  final String duration;
  final List<String> ingredients;
  final List<String> instructions;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> suitableMealTypes;
  final String cookingStyle;
  final List<String> keywords;

  PoolRecipe({
    required this.title,
    required this.duration,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.suitableMealTypes,
    required this.cookingStyle,
    required this.keywords,
  });
}
