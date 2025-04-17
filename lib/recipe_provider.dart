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
  List<String> nutrition;

  Recipe({
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    this.nutrition = const [],
  });
}

class RecipeProvider with ChangeNotifier {
  final FirebaseFirestore database = db;
  User? user;  // Start with null, will be set by auth state listener

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  RecipeProvider() {
    // Listen for user authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.user = user;  // Set the user to the current Firebase user
      if (user != null) {
        fetchRecipes();  // Fetch recipes when the user logs in
      } else {
        _clearRecipes();  // Clear recipes if the user logs out
      }
      notifyListeners();
    });
  }

  // Fetch recipes from Firestore for the logged-in user
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
        return Recipe(
          name: doc['name'],
          servings: doc['servings'],
          ingredients: (doc['ingredients'] as List).map((ingredientData) {
            return Item.fromFireStore(ingredientData);
          }).toList(),
          instructions: doc['instructions'],
          nutrition: List<String>.from(doc['nutrition']),
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Failed to fetch recipes: $error");
      }
    }
  }

  // Add a recipe for the logged-in user
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
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('recipes')
            .add({
          'name': recipe.name,
          'servings': recipe.servings,
          'ingredients': recipe.ingredients.map((item) => item.toMap()).toList(),
          'instructions': recipe.instructions,
          'nutrition': recipe.nutrition,
        });

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

  // Remove a recipe from Firestore for the logged-in user
  Future<void> removeRecipe(String name) async {
    if (user == null) {
      return;
    }

    try {
      final recipeSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .where('name', isEqualTo: name)  // Find recipe by name
          .get();

      if (recipeSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('recipes')
            .doc(recipeSnapshot.docs.first.id)  // Delete the document by ID
            .delete();

        _recipes.removeWhere((recipe) => recipe.name == name);  // Remove locally
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to remove recipe: $error");
      }
    }
  }

  // Update a recipe in Firestore for the logged-in user
  Future<void> updateRecipe(Recipe recipe) async {
    if (user == null) {
      return;
    }

    try {
      final recipesSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .where('name', isEqualTo: recipe.name)  // Find recipe by name
          .get();

      if (recipesSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('recipes')  // Correct path to 'recipes' collection
            .doc(recipesSnapshot.docs.first.id)  // Update the document by ID
            .update({
          'name': recipe.name,
          'servings': recipe.servings,
          'ingredients': recipe.ingredients.map((item) => item.toMap()).toList(),
          'instructions': recipe.instructions,
          'nutrition': recipe.nutrition,
        });

        // Update the local list as well
        int index = _recipes.indexWhere((i) => i.name == recipe.name);
        if (index != -1) {
          _recipes[index] = recipe;  // Update locally
          notifyListeners();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to update recipe: $error");
      }
    }
  }

  // Clear the local recipe list
  void _clearRecipes() {
    _recipes = [];
    notifyListeners();
  }
}
