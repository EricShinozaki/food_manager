import 'package:flutter/material.dart';

class Item {
  String name;
  double quantity;
  String note;
  List<String> nutrition;

  Item({
    required this.name,
    required this.quantity,
    required this.note,
    this.nutrition = const [],
  });
}

class ItemProvider with ChangeNotifier {
  final List<Item> items = [
    Item(name: "Apple", quantity: 2.5, note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, note: "Keep refrigerated"),
    Item(name: "Rice", quantity: 5.0, note: "Carb", nutrition: ["Carbs: High"]),
    Item(name: "Apple", quantity: 2.5, note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, note: "Keep refrigerated"),
    Item(name: "Rice", quantity: 5.0, note: "Carb", nutrition: ["Carbs: High"]),
    Item(name: "Apple", quantity: 2.5, note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, note: "Keep refrigerated"),
    Item(name: "Rice", quantity: 5.0, note: "Carb", nutrition: ["Carbs: High"]),
    Item(name: "Apple", quantity: 2.5, note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, note: "Keep refrigerated"),
    Item(name: "Rice", quantity: 5.0, note: "Carb", nutrition: ["Carbs: High"]),
    Item(name: "Apple", quantity: 2.5, note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, note: "Keep refrigerated"),
    Item(name: "Rice", quantity: 5.0, note: "Carb", nutrition: ["Carbs: High"]),
    Item(name: "Apple", quantity: 2.5, note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, note: "Keep refrigerated"),
    Item(name: "Rice", quantity: 5.0, note: "Carb", nutrition: ["Carbs: High"]),
  ];

  void addItem(Item item) {
    items.add(item);
    notifyListeners(); // Notify listeners of change
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners(); // Notify listeners of change
  }
}
