import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';

class Recipe {
  String name;
  double servings;
  List<Item> ingredients;
  String instructions;
  Map<String, int>? nutrition;

  Recipe({
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    this.nutrition,
  });
}


class RecipeProvider with ChangeNotifier {
  final List<Recipe> recipes = [
    Recipe(
      name: "Spaghetti Carbonara",
      servings: 2,
      ingredients: [
        Item(name: "Spaghetti", quantity: 200, unit: "g", note: "Use high-quality pasta for better texture."),
        Item(name: "Eggs", quantity: 2, unit: "pcs", note: "Use fresh eggs for a richer sauce."),
        Item(name: "Pancetta", quantity: 100, unit: "g", note: "Can be substituted with bacon."),
        Item(name: "Parmesan Cheese", quantity: 50, unit: "g", note: "Grate finely for easy mixing."),
        Item(name: "Black Pepper", quantity: 1, unit: "tsp", note: "Freshly ground for best flavor."),
      ],
      instructions: "Cook spaghetti. Fry pancetta. Mix eggs and cheese. Combine everything.",
      nutrition: {"Calories": 700, "Protein": 40, "Carbs": 60, "Fat": 30},
    ),
    Recipe(
      name: "Chicken Stir Fry",
      servings: 3,
      ingredients: [
        Item(name: "Chicken Breast", quantity: 300, unit: "g", note: "Slice thinly for faster cooking."),
        Item(name: "Bell Peppers", quantity: 2, unit: "pcs", note: "Use different colors for a vibrant dish."),
        Item(name: "Soy Sauce", quantity: 3, unit: "tbsp", note: "Low-sodium version for a healthier option."),
        Item(name: "Garlic", quantity: 2, unit: "cloves", note: "Mince finely for better distribution."),
        Item(name: "Ginger", quantity: 1, unit: "tsp", note: "Freshly grated is best."),
      ],
      instructions: "Slice chicken and veggies. Stir-fry with garlic and ginger. Add soy sauce.",
      nutrition: {"Calories": 450, "Protein": 50, "Carbs": 20, "Fat": 15},
    ),
    Recipe(
      name: "Pancakes",
      servings: 4,
      ingredients: [
        Item(name: "Flour", quantity: 200, unit: "g", note: "Use all-purpose or whole wheat flour."),
        Item(name: "Milk", quantity: 300, unit: "ml", note: "Can be substituted with plant-based milk."),
        Item(name: "Eggs", quantity: 2, unit: "pcs", note: "Room temperature eggs mix better."),
        Item(name: "Sugar", quantity: 2, unit: "tbsp", note: "Adjust based on sweetness preference."),
        Item(name: "Baking Powder", quantity: 1, unit: "tsp", note: "Ensures fluffy pancakes."),
      ],
      instructions: "Mix ingredients. Cook in a pan until golden brown on both sides.",
      nutrition: {"Calories": 350, "Protein": 10, "Carbs": 60, "Fat": 8},
    ),
    Recipe(
      name: "Avocado Toast",
      servings: 1,
      ingredients: [
        Item(name: "Bread", quantity: 2, unit: "slices", note: "Whole grain for extra fiber."),
        Item(name: "Avocado", quantity: 1, unit: "pcs", note: "Ripe avocado mashes easily."),
        Item(name: "Salt", quantity: 1, unit: "pinch", note: "Sea salt enhances flavor."),
        Item(name: "Lemon Juice", quantity: 1, unit: "tsp", note: "Prevents browning."),
      ],
      instructions: "Mash avocado with lemon and salt. Spread on toasted bread.",
      nutrition: {"Calories": 300, "Protein": 6, "Carbs": 30, "Fat": 18},
    ),
    Recipe(
      name: "Banana Smoothie",
      servings: 2,
      ingredients: [
        Item(name: "Banana", quantity: 2, unit: "pcs", note: "Use ripe bananas for natural sweetness."),
        Item(name: "Milk", quantity: 250, unit: "ml", note: "Dairy or plant-based milk works."),
        Item(name: "Honey", quantity: 1, unit: "tbsp", note: "Optional, adjust sweetness to taste."),
        Item(name: "Yogurt", quantity: 100, unit: "g", note: "Adds creaminess and probiotics."),
      ],
      instructions: "Blend all ingredients until smooth.",
      nutrition: {"Calories": 200, "Protein": 8, "Carbs": 40, "Fat": 3},
    ),
    Recipe(
      name: "Vegetable Soup",
      servings: 4,
      ingredients: [
        Item(name: "Carrots", quantity: 2, unit: "pcs", note: "Dice evenly for quick cooking."),
        Item(name: "Potatoes", quantity: 2, unit: "pcs", note: "Peel if preferred."),
        Item(name: "Onion", quantity: 1, unit: "pcs", note: "Chop finely."),
        Item(name: "Vegetable Broth", quantity: 1, unit: "L", note: "Low-sodium for a healthier option."),
        Item(name: "Garlic", quantity: 2, unit: "cloves", note: "Adds depth of flavor."),
      ],
      instructions: "Chop vegetables. Simmer in broth until tender. Season to taste.",
      nutrition: {"Calories": 150, "Protein": 5, "Carbs": 30, "Fat": 2},
    ),
    Recipe(
      name: "Grilled Cheese Sandwich",
      servings: 1,
      ingredients: [
        Item(name: "Bread", quantity: 2, unit: "slices", note: "Use thick slices for better texture."),
        Item(name: "Cheese", quantity: 2, unit: "slices", note: "Cheddar or American cheese works well."),
        Item(name: "Butter", quantity: 1, unit: "tbsp", note: "Spread evenly on bread."),
      ],
      instructions: "Butter bread. Add cheese. Grill until golden brown on both sides.",
      nutrition: {"Calories": 400, "Protein": 12, "Carbs": 35, "Fat": 22},
    ),
    Recipe(
      name: "Omelette",
      servings: 1,
      ingredients: [
        Item(name: "Eggs", quantity: 2, unit: "pcs", note: "Whisk well for a fluffy texture."),
        Item(name: "Milk", quantity: 1, unit: "tbsp", note: "Optional for a creamier omelette."),
        Item(name: "Cheese", quantity: 30, unit: "g", note: "Shred for even melting."),
        Item(name: "Spinach", quantity: 20, unit: "g", note: "Fresh or frozen both work."),
      ],
      instructions: "Whisk eggs. Cook in a pan. Add cheese and spinach. Fold and serve.",
      nutrition: {"Calories": 250, "Protein": 20, "Carbs": 5, "Fat": 18},
    ),
    Recipe(
      name: "Caesar Salad",
      servings: 2,
      ingredients: [
        Item(name: "Romaine Lettuce", quantity: 1, unit: "head", note: "Chop into bite-sized pieces."),
        Item(name: "Parmesan Cheese", quantity: 50, unit: "g", note: "Grate finely."),
        Item(name: "Croutons", quantity: 50, unit: "g", note: "Homemade or store-bought."),
        Item(name: "Caesar Dressing", quantity: 3, unit: "tbsp", note: "Use a high-quality dressing."),
      ],
      instructions: "Toss lettuce, cheese, croutons, and dressing together.",
      nutrition: {"Calories": 350, "Protein": 10, "Carbs": 20, "Fat": 25},
    ),
    Recipe(
      name: "Fruit Salad",
      servings: 2,
      ingredients: [
        Item(name: "Strawberries", quantity: 100, unit: "g", note: "Slice for easy eating."),
        Item(name: "Blueberries", quantity: 100, unit: "g", note: "Rinse before use."),
        Item(name: "Banana", quantity: 1, unit: "pcs", note: "Slice just before serving."),
        Item(name: "Honey", quantity: 1, unit: "tbsp", note: "Optional for added sweetness."),
      ],
      instructions: "Mix all fruits together. Drizzle with honey if desired.",
      nutrition: {"Calories": 200, "Protein": 2, "Carbs": 45, "Fat": 1},
    ),
  ];

  void addRecipe(Recipe recipe){
    recipes.add(recipe);
    notifyListeners();
  }

  void removeItem(int index){
    recipes.remove(index);
    notifyListeners();
  }
}

