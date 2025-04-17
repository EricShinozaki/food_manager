import 'package:flutter/material.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipe = recipeProvider.recipes.firstWhere((recipe) => recipe.name == widget.title);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Servings
          ListTile(
            title: Text(
              "Servings: ${recipe.servings}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          // Ingredients header
          const ListTile(
            title: Text(
              "Ingredients List",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          // Ingredients list
          ...recipe.ingredients.map((ingredient) => ListTile(
            title: Text(
              "${ingredient.quantity} ${ingredient.unit} ${ingredient.name}",
              style: const TextStyle(fontSize: 20),
            ),
          )),

          // Instructions header
          const ListTile(
            title: Text(
              "Instructions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          // Instructions content
          ListTile(
            title: Text(
              recipe.instructions,
              style: const TextStyle(fontSize: 20),
            ),
          ),

          // Nutrition header and content
          if (recipe.nutrition.isNotEmpty) ...[
            const ListTile(
              title: Text(
                "Nutrition Facts",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            ...recipe.nutrition.map((fact) => ListTile(
              title: Text(
                fact,
                style: const TextStyle(fontSize: 20),
              ),
            )),
          ],

          ...[
            if (recipe.nutrition.isNotEmpty)
              const ListTile(
                title: Text(
                  "Nutrition",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),

            ...recipe.nutrition.map((nutritionData) => ListTile(
              title: Text(
                nutritionData,
                style: const TextStyle(fontSize: 20),
              ),
            )),
          ],
        ],
      ),
    );
  }
}
