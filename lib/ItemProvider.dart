import 'package:flutter/material.dart';

class Item {
  String name;
  double quantity;
  String unit;
  String note;
  List<String> nutrition;

  Item({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.note, // Reminder, this can be left as empty string if no note
    this.nutrition = const [],
  });
}

class ItemProvider with ChangeNotifier {
  final List<Item> items = [
    Item(name: "Apple", quantity: 2.5, unit: "kg", note: "Fruit"),
    Item(name: "Milk", quantity: 1.0, unit: "L", note: "Keep refrigerated"),
    Item(
        name: "Rice",
        quantity: 5.0,
        unit: "kg",
        note: "Carb",
        nutrition: ["Carbs: High"]),
    Item(
        name: "Banana",
        quantity: 6.0,
        unit: "pieces",
        note: "High in potassium",
        nutrition: ["Carbs: Moderate"]),
    Item(
        name: "Chicken Breast",
        quantity: 3.0,
        unit: "kg",
        note: "High protein",
        nutrition: ["Protein: High"]),
    Item(
        name: "Carrot",
        quantity: 1.5,
        unit: "kg",
        note: "Good for eyesight",
        nutrition: ["Vitamin A"]),
    Item(
        name: "Eggs",
        quantity: 12.0,
        unit: "pieces",
        note: "Free range",
        nutrition: ["Protein: Moderate"]),
    Item(
        name: "Spinach",
        quantity: 1.0,
        unit: "kg",
        note: "Leafy green",
        nutrition: ["Iron", "Vitamin K"]),
    Item(
        name: "Tomato",
        quantity: 4.0,
        unit: "pieces",
        note: "High in Vitamin C",
        nutrition: ["Vitamin C: High"]),
    Item(
        name: "Avocado",
        quantity: 2.0,
        unit: "pieces",
        note: "Rich in healthy fats",
        nutrition: ["Healthy Fats: High"]),
    Item(
        name: "Bread",
        quantity: 1.0,
        unit: "loaf",
        note: "Whole grain",
        nutrition: ["Carbs: Moderate", "Fiber: Moderate"]),
    Item(
        name: "Yogurt",
        quantity: 500.0,
        unit: "g",
        note: "Low-fat",
        nutrition: ["Calcium", "Protein"]),
    Item(
        name: "Cucumber",
        quantity: 3.0,
        unit: "pieces",
        note: "Hydrating",
        nutrition: ["Vitamin K"]),
    Item(
        name: "Potatoes",
        quantity: 5.0,
        unit: "kg",
        note: "Starchy",
        nutrition: ["Carbs: High"]),
    Item(
        name: "Almonds",
        quantity: 0.5,
        unit: "kg",
        note: "Great snack",
        nutrition: ["Healthy Fats: High", "Protein: Moderate"]),
    Item(
        name: "Orange",
        quantity: 6.0,
        unit: "pieces",
        note: "Citrus fruit",
        nutrition: ["Vitamin C: High"]),
    Item(
        name: "Cheese",
        quantity: 200.0,
        unit: "g",
        note: "Full fat",
        nutrition: ["Calcium", "Fat"]),
    Item(
        name: "Oats",
        quantity: 1.0,
        unit: "kg",
        note: "Good for breakfast",
        nutrition: ["Fiber: High"]),
    Item(
        name: "Coconut Milk",
        quantity: 2.0,
        unit: "L",
        note: "Dairy-free",
        nutrition: ["Fat: High"]),
    Item(
        name: "Beef Steak",
        quantity: 3.0,
        unit: "kg",
        note: "High in protein",
        nutrition: ["Protein: High"]),
    Item(
        name: "Lemon",
        quantity: 5.0,
        unit: "pieces",
        note: "Sour",
        nutrition: ["Vitamin C: Moderate"]),
    Item(
        name: "Sweet Potato",
        quantity: 4.0,
        unit: "pieces",
        note: "Rich in Vitamin A",
        nutrition: ["Vitamin A: High"]),
    Item(
        name: "Pineapple",
        quantity: 2.0,
        unit: "pieces",
        note: "Tropical fruit",
        nutrition: ["Vitamin C: High"]),
    Item(
        name: "Peanut Butter",
        quantity: 1.0,
        unit: "kg",
        note: "Great for sandwiches",
        nutrition: ["Protein: Moderate", "Fat: High"]),
    Item(
        name: "Broccoli",
        quantity: 1.0,
        unit: "kg",
        note: "Rich in fiber",
        nutrition: ["Vitamin C", "Fiber"]),
  ];

  void addItem(Item item) {
    items.add(item);
    notifyListeners(); // Notify listeners of change
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners(); // Notify listeners of change
  }

  void sortItemsByName() {
    items.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void sortItemsByQuantity() {
    items.sort((a, b) => a.quantity.compareTo(b.quantity));
    notifyListeners();
  }
}
