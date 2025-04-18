import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:food_manager/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key, required this.title});
  final String title;

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final nameController = TextEditingController();
  final servingsController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionController = TextEditingController();
  final nutritionController = TextEditingController();
  final linkController = TextEditingController();
  final unitController = TextEditingController();
  final ingredientNameController = TextEditingController();
  final quantityController = TextEditingController();

  List<String> nutritionData = [];
  List<Item> ingredientList = [];

  final _formKey = GlobalKey<FormState>();
  final _ingredientFormKey = GlobalKey<FormState>();

  void addNutrition() {
    final nutritionItem = nutritionController.text;
    if (nutritionItem.isNotEmpty) {
      setState(() {
        nutritionData.add(nutritionItem);
      });
    }
    nutritionController.clear();
  }

  void addIngredientToRecipe() {
    final ingredient = ingredientNameController.text;
    final unit = unitController.text;
    double? quantity = _parseFraction(quantityController.text);
    double quantityAsDouble = quantity ?? 0.0;
    quantityAsDouble = double.parse(quantityAsDouble.toStringAsFixed(2));

    if (ingredient.isNotEmpty) {
      setState(() {
        ingredientList.add(Item(name: ingredient, quantity: quantityAsDouble, unit: unit, note: ''));
      });
    }

    unitController.clear();
    ingredientNameController.clear();
    quantityController.clear();
  }

  double? parseServings() {
    final servingsText = servingsController.text;
    return double.tryParse(servingsText);
  }

  Future<String> add() async {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    double? servings = parseServings();
    double servingsAsInt = servings ?? 0.0;

    Recipe recipe = Recipe(
        name: nameController.text,
        servings: servingsAsInt,
        ingredients: ingredientList,
        instructions: instructionController.text,
        nutrition: nutritionData,
        link: linkController.text.isNotEmpty ? linkController.text : null
    );

    return await recipeProvider.addRecipe(recipe);
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _ingredientRequiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _requiredDoubleValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Number required';
    final parsed = _parseFraction(value.trim());
    if (parsed == null) return 'Invalid';
    return null;
  }

  double? _parseFraction(String input) {
    try {
      if (input.contains(' ')) {
        final parts = input.split(' ');
        if (parts.length != 2) return null;
        final whole = double.parse(parts[0]);
        final frac = _parseSimpleFraction(parts[1]);
        return whole + (frac ?? 0);
      } else if (input.contains('/')) {
        return _parseSimpleFraction(input);
      } else {
        return double.parse(input);
      }
    } catch (_) {
      return null;
    }
  }

  double? _parseSimpleFraction(String input) {
    final parts = input.split('/');
    if (parts.length != 2) return null;

    final numerator = double.tryParse(parts[0]);
    final denominator = double.tryParse(parts[1]);
    if (numerator == null || denominator == null || denominator == 0) {
      return null;
    }

    return numerator / denominator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: nameController,
                  validator: _requiredValidator,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Recipe Name',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: linkController,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Link to recipe',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: servingsController,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Servings',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _ingredientFormKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: quantityController,
                          validator: _requiredDoubleValidator,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            labelText: 'Quantity',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: unitController,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            labelText: 'Unit',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: ingredientNameController,
                          validator: _ingredientRequiredValidator,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            labelText: 'Ingredient',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_ingredientFormKey.currentState!.validate()) {
                            addIngredientToRecipe();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    Text("Added Ingredients:", style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ...ingredientList.asMap().entries.map((entry) {
                      int index = entry.key;
                      Item value = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Text("${value.quantity} ${value.unit} ${value.name}", style: const TextStyle(color: Colors.black, fontSize: 20)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(() {
                              ingredientList.removeAt(index);
                            }),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: instructionController,
                  validator: _requiredValidator,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Instructions',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: nutritionController,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Nutrition',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: addNutrition,
                    ),
                  ),
                ),
              ),
              if(nutritionData.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    children: [
                      Text(
                          "Added Nutrition info:",
                          style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      ...nutritionData.asMap().entries.map((entry) {
                        int index = entry.key;
                        String value = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: Text(value, style: const TextStyle(color: Colors.black, fontSize: 20)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => setState(() {
                                nutritionData.removeAt(index);
                              }),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String result = await add();
                    if (!context.mounted) return;

                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => AlertDialog(
                        content: Text(result, style: const TextStyle(fontSize: 18)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );

                    if (result == "Recipe added successfully") {
                      nameController.clear();
                      quantityController.clear();
                      unitController.clear();
                      linkController.clear();
                      servingsController.clear();
                      nutritionController.clear();
                      ingredientsController.clear();
                      instructionController.clear();
                      ingredientList.clear();
                      nutritionData.clear();
                      setState(() => nutritionData.clear());
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  foregroundColor: AppColors.buttonText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: const Text("Add Recipe"),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
