import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/main.dart';

class Recipe {
  String name;
  double servings;
  List<Item> ingredients;
  String instructions;
  double? time;
  List<String> nutrition;
  String? link;

  Recipe({
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    this.time,
    this.nutrition = const [],
    this.link,
  });
}

class RecipeProvider with ChangeNotifier {
  final FirebaseFirestore database = db;
  User? user;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  RecipeProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.user = user;
      if (user != null) {
        fetchRecipes();
      } else {
        _clearRecipes();
      }
      notifyListeners();
    });
  }

  Future<void> fetchRecipes() async {
    if (user == null) {
      if (kDebugMode) {
        print("User is not logged in.");
      }
      return;
    }

    try {
      _clearRecipes();
      final querySnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .get();

      _recipes = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Recipe(
          name: data['name'],
          servings: data['servings'],
          ingredients: (data['ingredients'] as List).map((ingredientData) {
            return Item.fromFireStore(ingredientData);
          }).toList(),
          instructions: data['instructions'],
          nutrition: List<String>.from(data['nutrition']),
          link: data.containsKey('link') ? data['link'] : null,
          time: data.containsKey('time') ? (data['time'] as num?)?.toDouble() : null,
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Failed to fetch recipes: $error");
      }
    }
  }

  Future<String> addRecipe(Recipe recipe) async {
    if (user == null) {
      return "User is not logged in.";
    }

    try {
      final existingRecipeSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .where('name', isEqualTo: recipe.name)
          .get();

      if (existingRecipeSnapshot.docs.isEmpty) {
        final newRecipe = {
          'name': recipe.name,
          'servings': recipe.servings,
          'ingredients': recipe.ingredients.map((item) => item.toMap()).toList(),
          'instructions': recipe.instructions,
          'nutrition': recipe.nutrition,
          if (recipe.link != null) 'link': recipe.link,
          if (recipe.time != null) 'time': recipe.time,
        };

        await database
            .collection('users')
            .doc(user?.uid)
            .collection('recipes')
            .add(newRecipe);

        _recipes.add(recipe);
        notifyListeners();
        return "Successfully added recipe";
      } else {
        if (kDebugMode) {
          print("Recipe with this name already exists");
        }
        return "Recipe with this name already exists.";
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to add recipe: $error");
      }
      return "Error: $error, please try again";
    }
  }

  Future<void> removeRecipe(String name) async {
    if (user == null) {
      return;
    }

    try {
      final recipeSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .where('name', isEqualTo: name)
          .get();

      if (recipeSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('recipes')
            .doc(recipeSnapshot.docs.first.id)
            .delete();

        _recipes.removeWhere((recipe) => recipe.name == name);
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to remove recipe: $error");
      }
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    if (user == null) {
      return;
    }

    try {
      final recipesSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .where('name', isEqualTo: recipe.name)
          .get();

      if (recipesSnapshot.docs.isNotEmpty) {
        final updatedRecipe = {
          'name': recipe.name,
          'servings': recipe.servings,
          'ingredients': recipe.ingredients.map((item) => item.toMap()).toList(),
          'instructions': recipe.instructions,
          'nutrition': recipe.nutrition,
          if (recipe.link != null) 'link': recipe.link,
          if (recipe.time != null) 'time': recipe.time,
        };

        await database
            .collection('users')
            .doc(user?.uid)
            .collection('recipes')
            .doc(recipesSnapshot.docs.first.id)
            .update(updatedRecipe);

        int index = _recipes.indexWhere((i) => i.name == recipe.name);
        if (index != -1) {
          _recipes[index] = recipe;
          notifyListeners();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to update recipe: $error");
      }
    }
  }

  void _clearRecipes() {
    _recipes = [];
    notifyListeners();
  }
}
