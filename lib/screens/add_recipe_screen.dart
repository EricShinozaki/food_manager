import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
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
  final timeController = TextEditingController(); // Added cooking time controller
  final ingredientsController = TextEditingController();
  final instructionController = TextEditingController();
  final nutritionController = TextEditingController();
  final linkController = TextEditingController();
  final unitController = TextEditingController();
  final ingredientNameController = TextEditingController();
  final quantityController = TextEditingController();

  List<String> nutritionData = [];
  List<Item> ingredientList = [];
  final List<String> units = ['tsp', 'tbsp', 'cup', 'pint', 'quart', 'gallon', 'oz', 'fl oz', 'lb', 'pieces'];
  String? selectedUnit;

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
    final unit = selectedUnit ?? '';
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
    setState(() {
      selectedUnit = null;
    });
  }

  double? parseServings() {
    final servingsText = servingsController.text;
    return double.tryParse(servingsText);
  }

  double? parseCookingTime() {
    final timeText = timeController.text;
    return double.tryParse(timeText);
  }

  Future<String> add() async {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    double? servings = parseServings();
    double servingsAsDouble = servings ?? 0.0;
    double? cookingTime = parseCookingTime(); // Parse cooking time
    double cookingTimeAsDouble = cookingTime ?? 0.0;

    Recipe recipe = Recipe(
        name: nameController.text,
        servings: servingsAsDouble,
        time: cookingTimeAsDouble, // Added cooking time to the recipe
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
              const SizedBox(height: 16),

              // Basic Recipe Information Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "Recipe Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: nameController,
                  validator: _requiredValidator,
                  minLines: 1,
                  maxLines: null,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Recipe Name',
                    prefixIcon: Icon(Icons.restaurant_menu),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: linkController,
                  minLines: 1,
                  maxLines: null,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Link to recipe',
                    hintText: 'Optional',
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ),

              Row(
                children: [
                  // Servings field
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
                      child: TextFormField(
                        controller: servingsController,
                        validator: _requiredDoubleValidator,
                        minLines: 1,
                        maxLines: null,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          labelText: 'Servings',
                          prefixIcon: Icon(Icons.people),
                        ),
                      ),
                    ),
                  ),
                  // Cooking time field
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20, left: 10, top: 5, bottom: 5),
                      child: TextFormField(
                        controller: timeController,
                        validator: _requiredDoubleValidator,
                        minLines: 1,
                        maxLines: null,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          labelText: 'Time (min)',
                          prefixIcon: Icon(Icons.timer),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Ingredients Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Form(
                  key: _ingredientFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add New Ingredient",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Quantity field
                      TextFormField(
                        controller: quantityController,
                        validator: _requiredDoubleValidator,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          labelText: 'Quantity',
                          prefixIcon: const Icon(Icons.scale),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Unit dropdown field
                      DropdownButtonFormField2(
                        value: selectedUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          prefixIcon: const Icon(Icons.straighten),
                        ),
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: MediaQuery.sizeOf(context).height * 0.3,
                          width: MediaQuery.sizeOf(context).width - 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        items: units.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedUnit = value),
                      ),

                      const SizedBox(height: 12),

                      // Ingredient name field
                      TextFormField(
                        controller: ingredientNameController,
                        validator: _ingredientRequiredValidator,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          labelText: 'Ingredient Name',
                          prefixIcon: const Icon(Icons.food_bank),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Add ingredient button
                      Center(
                        child: ElevatedButton.icon(
                          label: const Text('Add Ingredient'),
                          onPressed: () {
                            if (_ingredientFormKey.currentState!.validate()) {
                              addIngredientToRecipe();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackground,
                            foregroundColor: AppColors.buttonText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ingredients List
              if(ingredientList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.list),
                          const SizedBox(width: 8),
                          Text(
                            "Added Ingredients (${ingredientList.length})",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...ingredientList.asMap().entries.map((entry) {
                        int index = entry.key;
                        Item value = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Text(
                              "${value.quantity} ${value.unit} ${value.name}",
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                            ),
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

              // Instructions Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: instructionController,
                  validator: _requiredValidator,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Instructions',
                    alignLabelWithHint: true,
                  ),
                ),
              ),

              // Nutrition Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  "Nutrition Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: nutritionController,
                  minLines: 1,
                  maxLines: null,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Nutrition Info',
                    hintText: 'e.g., Calories: 240 kcal',
                    prefixIcon: const Icon(Icons.monitor_weight),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: addNutrition,
                    ),
                  ),
                ),
              ),

              // Nutrition List
              if(nutritionData.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant),
                            const SizedBox(width: 8),
                            Text(
                              "Added Nutrition Info (${nutritionData.length})",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...nutritionData.asMap().entries.map((entry) {
                          int index = entry.key;
                          String value = entry.value;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: Text(value, style: const TextStyle(color: Colors.black, fontSize: 16)),
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
                    )
                ),

              // Submit Button
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 32),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String result = await add();
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result),
                            backgroundColor: result == "Recipe added successfully"
                                ? Colors.green
                                : Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );

                        if (result == "Recipe added successfully") {
                          nameController.clear();
                          timeController.clear();
                          quantityController.clear();
                          unitController.clear();
                          linkController.clear();
                          servingsController.clear();
                          nutritionController.clear();
                          ingredientsController.clear();
                          instructionController.clear();
                          ingredientList.clear();
                          nutritionData.clear();
                          setState(() {
                            nutritionData.clear();
                            selectedUnit = null;
                          });
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.buttonBackground,
                      foregroundColor: AppColors.buttonText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: const Text(
                      "SAVE RECIPE",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}