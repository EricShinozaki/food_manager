import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final items = itemProvider.items;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = [];
    HashSet<String> usersItems = HashSet<String>();

    for(Item i in items){
      usersItems.add(i.name.toLowerCase());
    }

    for(Recipe recipe in recipeProvider.recipes){
      bool hasAllIngredients = true;

      for(Item item in recipe.ingredients){
        if(!usersItems.contains(item.name)){
          hasAllIngredients = false;
        }
      }

      if(hasAllIngredients){
        recipes.add(recipe);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        children: [
          ListTile(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recipes you can make",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
              ),
            )
          ),

          if (recipes.isNotEmpty) ...[
            ...recipes.map((recipe) => ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -4),
              title: Center(
                child: Text(
                  recipe.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )),
          ],

          if(recipes.isEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ListTile(
                title: Center(
                  child: Text(
                    "There aren't any recipes you can make with your current ingredients. Try adding more recipes",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              )
            )
          ]
        ]
      )
    );
  }
}
