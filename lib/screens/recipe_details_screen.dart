import 'package:flutter/material.dart';
import 'package:food_manager/recipeProvider.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = RecipeProvider().recipes.firstWhere((recipe) => recipe.name == widget.title);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 35, bottom: 10),
                      child: Text(
                        "${recipe.name} \nServings: ${recipe.servings}",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Expanded(
              flex: 15,
              child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Text(
                            "Notes: ",
                            style: TextStyle(
                                fontSize: 20
                            )
                        )
                    )
                  ]
              ),
            ),
            Expanded(
              flex: 15,
              child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Text(
                            "Nutrition: ",
                            style: TextStyle(
                                fontSize: 20
                            )
                        )
                    )
                  ]
              ),
            ),
          ],
        )
    );
  }
}
