import 'package:flutter/material.dart';
import 'package:food_manager/recipeProvider.dart';
import 'package:go_router/go_router.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key, required this.title});

  final String title;

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: RecipeProvider().recipes.length,
          itemBuilder: (context, index){
            final recipe = RecipeProvider().recipes[index];
            return ListTile(
                title: Text(recipe.name),
                subtitle: Text("Servings: ${recipe.servings}"),
                onTap: () {
                  context.go('/recipes/recipeDetails/${recipe.name}');
                }
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