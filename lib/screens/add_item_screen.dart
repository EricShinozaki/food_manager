import 'package:flutter/material.dart';

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

  void addItem() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Column(children: [
          Column(children: [
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
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
              child: TextField(
                obscureText: false,
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
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
              child: TextField(
                obscureText: false,
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
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
              child: TextField(
                obscureText: false,
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
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: false,
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
                    )
                  ],
                )),
            SizedBox(height: 20),
            Text("Added Nutrition Data:"),
            ...nutritionData.map((data) => Text(data)),
          ]),
          Container(
              padding: EdgeInsets.all(20),
              child: FilledButton.tonal(
                  onPressed: addItem,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black),
                    )),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text("Add item")))
        ])));
  }
}
