import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Item = ItemProvider().items.firstWhere((item) => item.name == widget.title);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
          children: [
            Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 35, top: 10, bottom: 10),
                        child: Text(
                          "${Item.name} \nQuantity: ${Item.quantity} ${Item.unit}",
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
                      margin: EdgeInsets.only(left: 15, right: 35),
                        child: Text(
                          "Notes: ${Item.note}",
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
                        margin: EdgeInsets.only(left: 15, right: 35),
                        child: Text(
                            "Nutrition: ${getNutritionString(Item)}",
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

  String getNutritionString(Item item){
    String nutritionString = "";

    for(String s in item.nutrition){
      nutritionString += "$s\n";
    }

    if(nutritionString == ""){
      return "N/A";
    }

    return nutritionString;
  }
}
