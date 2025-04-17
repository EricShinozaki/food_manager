import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    HashSet<String> usersItems = HashSet<String>();

    for(Item i in items){
      usersItems.add(i.name.toLowerCase());
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
                      decoration: TextDecoration.underline,
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
                        usersItems.contains(ingredient.name.toLowerCase())
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

          // Optional greyed-out "Nutrition" section
          if (recipe.nutrition.isNotEmpty) ...[
            const ListTile(
              title: Center(
                child: Text(
                  "Nutrition",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            ),
            ...recipe.nutrition.map((nutritionData) => ListTile(
              title: Center(
                child: Text(
                  nutritionData,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }
}
