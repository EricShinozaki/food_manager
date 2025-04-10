import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.title});

  final String title;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final noteController = TextEditingController();
  final nutritionController = TextEditingController();

  List<String> nutritionData = [];

  void addNutrition() {
    final nutritionItem = nutritionController.text;

    if (nutritionItem.isNotEmpty) {
      setState(() {
        nutritionData.add(nutritionItem);
      });

      nutritionController.clear();
    }
  }

  Future<void> add() async {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    double? quantity = parseQuantity();
    double quantityAsDouble = quantity ?? 0.0;

    Item item = Item(
      name: nameController.text,
      quantity: quantityAsDouble,
      unit: unitController.text,
      note: noteController.text,
      nutrition: nutritionData,
    );

    await itemProvider.addItem(item);
  }

  double? parseQuantity() {
    final quantityText = quantityController.text;
    final value = double.tryParse(quantityText);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Item Name',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Item Quantity',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(
                controller: unitController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Item Unit Placeholder',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(
                controller: noteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Notes',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nutritionController,
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
                ],
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
                onPressed: add,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text("Add item"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

