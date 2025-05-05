import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/conversions.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

_launchURLBrowser(String? url) async {
  var _url = Uri.parse(url!);
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $_url');
  }
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final items = itemProvider.items;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipe = recipeProvider.recipes.firstWhere((recipe) => recipe.name == widget.title);
    HashSet<String> itemsInRecipe = HashSet<String>();
    HashSet<String> usersItems = HashSet<String>();
    HashMap<String, double> itemQuantity = HashMap<String, double>();
    HashMap<String, String> itemUnit = HashMap<String, String>();
    final converter = MeasurementConverter();

    for(Item i in recipe.ingredients){
      itemsInRecipe.add(i.name);
    }

    for(Item i in items){
      if(itemsInRecipe.contains(i.name)){
        usersItems.add(i.name.toLowerCase());
        itemQuantity[i.name] = i.quantity;
        itemUnit[i.name] = i.unit;
      }
    }

    bool hasEnough(String ingredientName, Item recipeIngredientInfo){
      if(!usersItems.contains(ingredientName)){
        return false;
      }

      var converted = converter.convert(itemUnit[ingredientName]!, recipeIngredientInfo.unit) * itemQuantity[ingredientName]!;

      if(converted < recipeIngredientInfo.quantity){
        return false;
      }

      return true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Link
          if (recipe.link != null) ...[
            ListTile(
              title: Center(
                child: TextButton(
                  onPressed: () {
                    _launchURLBrowser(recipe.link);
                  },
                  child: const Text(
                    "Link to recipe",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Servings
          ListTile(
            title: const Center(
              child: Text(
                "Servings:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            subtitle: Center(
              child: Text(
                "${recipe.servings}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),

          // Ingredients header
          const ListTile(
            title: Center(
              child: Text(
                "Ingredients List",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),

          // Ingredients list
          ...recipe.ingredients.map((ingredient) => ListTile(
            title: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  // Group the icon + quantity/unit together
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasEnough(ingredient.name.toLowerCase(), ingredient)
                            ? Icons.check
                            : Icons.close,
                        size: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${ingredient.quantity} ${ingredient.unit}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    ingredient.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          )),

          // Instructions header
          const ListTile(
            title: Center(
              child: Text(
                "Instructions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),

          // Instructions content
          ListTile(
            title: Center(
              child: Text(
                recipe.instructions,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),

          // Nutrition header and content
          if (recipe.nutrition.isNotEmpty) ...[
            const ListTile(
              title: Center(
                child: Text(
                  "Nutrition Facts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            ...recipe.nutrition.map((fact) => ListTile(
              title: Center(
                child: Text(
                  fact,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            )),
          ],

          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade600, Colors.red.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Remove ${recipe.name}"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              recipeProvider.removeRecipe(recipe.name);
                              context.go('/recipes');
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                child: Text(
                  "Delete recipe",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
