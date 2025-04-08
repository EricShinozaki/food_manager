import 'package:flutter/material.dart';

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

  List<String> nutritionData = [];
  List<String> itemList = [];

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
    final ingredient = ingredientsController.text;

    if(ingredient.isNotEmpty){
      setState(() {
        itemList.add(ingredient);
      });
    }

    nutritionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      labelText: 'Item Name',
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: servingsController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Servings',
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: ingredientsController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Ingredient',
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: instructionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Instructions',
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      obscureText: false,
                      controller: nutritionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Nutrition',
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}
