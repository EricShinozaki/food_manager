import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';
import 'package:food_manager/recipeProvider.dart';
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

  final unitController = TextEditingController();
  final ingredientNameController = TextEditingController();
  final quantityController = TextEditingController();

  List<String> nutritionData = [];
  List<Item> ingredientList = [];

  final _formKey = GlobalKey<FormState>();
  final _ingredientFormKey = GlobalKey<FormState>();

  void addNutrition(){
    final nutritionItem = nutritionController.text;

    if(nutritionItem.isNotEmpty){
      setState(() {
        nutritionData.add(nutritionItem);
      });
    }

    nutritionController.clear();
  }

  void addIngredientToRecipe(){
    final ingredient = ingredientNameController.text;
    final unit = unitController.text;
    double? quantity = parseQuantity();
    double quantityAsDouble = quantity ?? 0.0;

    if(ingredient.isNotEmpty){
      setState(() {
        ingredientList.add(new Item(name: ingredient, quantity: quantityAsDouble, unit: unit, note: ''));
      });
    }

    unitController.clear();
    ingredientNameController.clear();
    quantityController.clear();
  }

  double? parseQuantity() {
    final quantityText = quantityController.text;
    final value = double.tryParse(quantityText);
    return value;
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
    );

    return await recipeProvider.addRecipe(recipe);
  }

  double? parseServings() {
    final servingsText = servingsController.text;
    final value = double.tryParse(servingsText);
    return value;
  }

  String? _requiredValidator(String? value) {
    if(value == null || value.trim().isEmpty){
      return 'This field is required';
    }
    return null;
  }

  String? _ingredientRequiredValidator(String? value) {
    if(value == null || value.trim().isEmpty){
      return 'Required';
    }
    return null;
  }

  String? _requiredDoubleValidator(String? value) {
    double? servings = parseServings();

    if(servings == null){
      return 'required';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextFormField(
                      validator: _requiredValidator,
                      obscureText: false,
                      controller: nameController,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      labelText: 'Recipe Name',
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: servingsController,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Servings',
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: Form(
                      key: _ingredientFormKey,
                      child: Row(
                        children: [
                          // Name TextField
                          Expanded(
                            child: TextFormField(
                              validator: _ingredientRequiredValidator,
                              controller: ingredientNameController,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Ingredient',
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Spacing between text fields
                          // Quantity TextField
                          Expanded(
                            child: TextFormField(
                              validator: _ingredientRequiredValidator,
                              controller: quantityController,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Quantity',
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Spacing between text fields
                          // Unit TextField
                          Expanded(
                            child: TextFormField(
                              validator: _ingredientRequiredValidator,
                              controller: unitController,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Unit',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if(_ingredientFormKey.currentState!.validate()){
                                setState(() {
                                  addIngredientToRecipe();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 40, right: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  "Added Ingredients:",
                                  style: TextStyle(
                                    fontSize: 20
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            ...ingredientList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Item data = entry.value;

                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    "${data.quantity} ${data.unit} ${data.name}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        ingredientList.removeAt(index);
                                      });
                                      // Update UI depending on context
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextFormField(
                      validator: _requiredValidator,
                      obscureText: false,
                      controller: instructionController,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Instructions',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: nutritionController,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Nutrition',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: addNutrition,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 40, right: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                                "Added Nutrition info:",
                                style: TextStyle(
                                    fontSize: 20
                                )
                            ),
                          ),
                          SizedBox(height: 10),
                          ...nutritionData.asMap().entries.map((entry) {
                            int index = entry.key;
                            String data = entry.value;

                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  data,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      nutritionData.removeAt(index);
                                    });
                                    // Update UI depending on context
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: FilledButton.tonal(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await add(); // Wait for the async function
                          if (result == "Successfully added recipe") {
                            nameController.clear();
                            servingsController.clear();
                            ingredientsController.clear();
                            instructionController.clear();
                            nutritionController.clear();
                            unitController.clear();
                            ingredientNameController.clear();
                            quantityController.clear();
                          }

                          if(context.mounted){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(
                                    result,
                                    style: TextStyle(
                                      fontSize: 25
                                    )
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context), // Closes the dialog
                                    child: Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Text("Add Recipe"),
                    ),
                  ),
                ]
              )
            )
        )
    );
  }
}
