import 'package:flutter/material.dart';
import 'package:food_manager/recipeProvider.dart';
import 'package:go_router/go_router.dart';
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 100,
              child: Column(
                  children: [
                    Expanded( // Ensures ListView gets proper constraints
                      child: ListView.builder(
                        itemCount: recipe.ingredients.length + recipe.nutrition!.length + 5,
                        itemBuilder: (context, index) {
                          if(index == 0) {
                            return ListTile(
                              title: Text("Servings: ${recipe.servings}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                            );
                          } else if (index == 1) {
                            return ListTile(
                              title: Text("Ingredients List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                            );
                          } else if(index > 1 && index < recipe.ingredients.length + 2){
                            final ingredient = recipe.ingredients[index - 2]; // Adjust index to match ingredient list
                            return ListTile(
                              title: Text("${ingredient.quantity} ${ingredient.unit} ${ingredient.name}", style: TextStyle(fontSize: 20)),
                              onTap: () {
                                //context.go('/recipes/recipeDetails/${recipe.name}/ingredientDetails/${ingredient.name}');
                              },
                            );
                          } else if(index == recipe.ingredients.length + 2){
                            return ListTile(
                              title: Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                            );
                          } else if(index == recipe.ingredients.length + 3){
                            return ListTile(
                              title: Text(recipe.instructions, style: TextStyle(fontSize: 20)),
                            );
                          } else if(index == recipe.ingredients.length + 4){
                            return ListTile(
                              title: Text("Nutrition facts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                            );
                          } else {
                            //final nutritionFact = recipe.nutrition[index - 5 - recipe.ingredients.length]; // Adjust index to match ingredient list
                            return ListTile(
                              title: Text("Add later", style: TextStyle(fontSize: 20)),
                            );
                          }
                        },
                      ),
                    ),
                  ]
              ),
            ),
          ],
        )
    );
  }
}
