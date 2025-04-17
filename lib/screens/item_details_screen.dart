import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:food_manager/theme/app_theme.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final Item = itemProvider.items.firstWhere((item) => item.name == title);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Allow the dialog to be as small as possible
        children: [
          // Display Name and Quantity
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "${Item.name} \nQuantity: ${Item.quantity} ${Item.unit}",
              style: TextStyle(fontSize: 18, color: AppColors.formBackground),
            ),
          ),
          // Display Notes
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Notes: ${Item.note}",
              style: TextStyle(fontSize: 18, color: AppColors.formBackground),
            ),
          ),
          // Display Nutrition
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Nutrition: ${getNutritionString(Item)}",
              style: TextStyle(fontSize: 18, color: AppColors.formBackground),
            ),
          ),
        ],
      ),
      actions: [
        // Close Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            "Close",
            style: TextStyle(color: AppColors.buttonBackground),
          ),
        ),
      ],
    );
  }

  String getNutritionString(Item item) {
    String nutritionString = "";

    for (String s in item.nutrition) {
      nutritionString += "$s\n";
    }

    if (nutritionString == "") {
      return "N/A";
    }

    return nutritionString;
  }
}

// Method to show the ItemDetailsScreen as a pop-up
void showItemDetails(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ItemDetailsScreen(title: title);
    },
  );
}
