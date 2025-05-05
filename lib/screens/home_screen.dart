import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:food_manager/utilities/conversions.dart';
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
    final recipes = <Recipe>[];
    final soonToExpireItems = <Item>[];
    final expiredItems = <Item>[];

    // Get current date for comparison
    final now = DateTime.now();
    final threeDaysLater = now.add(const Duration(days: 3));

    // Process items for recipes and expiration
    final converter = MeasurementConverter();
    HashSet<String> usersItems = HashSet<String>();
    HashMap<String, double> itemQuantity = HashMap<String, double>();
    HashMap<String, String> itemUnit = HashMap<String, String>();

    for(Item item in items) {
      usersItems.add(item.name.toLowerCase());
      itemQuantity[item.name] = item.quantity;
      itemUnit[item.name] = item.unit;
      // Check expiration status
      if (item.expirationDate != null) {
        if (item.expirationDate!.isBefore(now)) {
          expiredItems.add(item);
        } else if (item.expirationDate!.isBefore(threeDaysLater)) {
          soonToExpireItems.add(item);
        }
      }
    }

    // Find recipes with available ingredients
    for(Recipe recipe in recipeProvider.recipes) {
      bool hasAllIngredients = true;

      for(Item ingredient in recipe.ingredients) {
        if(usersItems.contains(ingredient.name.toLowerCase())) {
          var converted = -1.0;
          if(ingredient.unit == null || itemUnit[ingredient.name] == null){
            converted = itemQuantity[ingredient.name] ?? 1.0;
            converted *= itemQuantity[ingredient.name] ?? -1;
          } else {
            converted = converter.convert(itemUnit[ingredient.name]!, ingredient.unit) * itemQuantity[ingredient.name]!;
          }
          if(converted < ingredient.quantity){
            hasAllIngredients = false;
            break;
          }
        } else {
          hasAllIngredients = false;
        }
      }

      if(hasAllIngredients) {
        recipes.add(recipe);
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
          elevation: 4,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              children: [
                // Recipes section header
                Row(
                  children: [
                    Icon(Icons.restaurant, size: 24, color: Colors.blueGrey[700]),
                    const SizedBox(width: 8),
                    Text(
                      "Recipes you can make",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Recipes content
                if (recipes.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: recipes.map((recipe) => ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: -1),
                        title: Text(
                          recipe.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: const Icon(Icons.food_bank, color: Colors.green),
                      )).toList(),
                    ),
                  ),
                ],

                // Empty recipes state
                if(recipes.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.no_food, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "There aren't any recipes you can make with your current ingredients.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Try adding more ingredients or recipes.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Soon to expire section header
                Row(
                  children: [
                    Icon(Icons.access_time, size: 24, color: Colors.blueGrey[700]),
                    const SizedBox(width: 8),
                    Text(
                      "Soon to expire ingredients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Soon to expire content
                if (soonToExpireItems.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: soonToExpireItems.map((item) => ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 0),
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Expires: ${item.expirationDate!.month}/${item.expirationDate!.day}/${item.expirationDate!.year}",
                          style: const TextStyle(fontSize: 14, color: Colors.orange),
                        ),
                      )).toList(),
                    ),
                  ),
                ],

                // Empty soon to expire state
                if (soonToExpireItems.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "No ingredients expiring soon",
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Expired ingredients section header
                Row(
                  children: [
                    Icon(Icons.delete_outline, size: 24, color: Colors.blueGrey[700]),
                    const SizedBox(width: 8),
                    Text(
                      "Expired ingredients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Expired ingredients content
                if (expiredItems.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: expiredItems.map((item) => Dismissible(
                        key: Key(item.name),
                        background: Container(
                          color: Colors.red.shade100,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          itemProvider.removeItem(item.name);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} removed'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: 0),
                          leading: const Icon(Icons.not_interested, color: Colors.red),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Expired: ${item.expirationDate!.month}/${item.expirationDate!.day}/${item.expirationDate!.year}",
                            style: const TextStyle(fontSize: 14, color: Colors.red),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Remove ${item.name}"),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          itemProvider.removeItem(item.name);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${item.name} removed'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ],

                // Empty expired ingredients state
                if (expiredItems.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "No expired ingredients",
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ]
          ),
        )
    );
  }
}