import 'package:flutter/material.dart';
import 'package:food_manager/recipeProvider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
          itemCount: recipeProvider.recipes.length,
          itemBuilder: (context, index){
            final recipe = recipeProvider.recipes[index];
            return ListTile(
                title: Text(recipe.name, style: TextStyle(fontSize: 20)),
                subtitle: Text("Servings: ${recipe.servings}", style: TextStyle(fontSize: 15)),
                onTap: () {
                  context.go('/recipes/recipeDetails/${recipe.name}');
                },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/recipes/addRecipe'),
        tooltip: 'Add a recipe',
        child: const Icon(Icons.add),
      ), //
    );
  }
}