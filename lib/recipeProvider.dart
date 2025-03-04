import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';

class Recipe {
  String name;
  double servings;
  Map<int, Item> ingredients;
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
  List<Recipe> recipes = [];

  void addRecipe(Recipe recipe){
    recipes.add(recipe);
    notifyListeners();
  }

  void removeItem(int index){
    recipes.remove(index);
    notifyListeners();
  }
}

