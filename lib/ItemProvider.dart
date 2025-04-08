import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/main.dart';

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
  final FirebaseFirestore database = db;
  User? user = FirebaseAuth.instance.currentUser;

  List<Item> _items = [];
  List<Item> get items => _items;

  // Fetch items from Firestore for the logged-in user
  Future<void> fetchItems() async {
    try {
      final querySnapshot = await database
          .collection('users')
          .doc(user?.uid)  // Use the user ID to fetch items specific to the user
          .collection('items')  // This will now be under the user's document
          .get();

      _items = querySnapshot.docs.map((doc) {
        return Item(
          name: doc['name'],
          quantity: doc['quantity'].toDouble(),
          unit: doc['unit'],
          note: doc['note'],
          nutrition: List<String>.from(doc['nutrition']),
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Failed to fetch items: $error");
      }
    }
  }

  // Add an item to Firestore for the logged-in user
  Future<void> addItem(Item item) async {
    try {
      // Check if the item with the same name already exists
      final existingItemSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .where('name', isEqualTo: item.name)  // Check by item name
          .get();

      if (existingItemSnapshot.docs.isEmpty) {
        // Add the item only if it doesn't exist
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('items')
            .add({
          'name': item.name,
          'quantity': item.quantity,
          'unit': item.unit,
          'note': item.note,
          'nutrition': item.nutrition,
        });

        _items.add(item);  // Add item locally
        notifyListeners();
      } else {
        if (kDebugMode) {
          print("Item with this name already exists");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to add item: $error");
      }
    }
  }

  // Remove an item from Firestore by name for the logged-in user
  Future<void> removeItem(String name) async {
    try {
      final itemSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .where('name', isEqualTo: name)  // Find item by name
          .get();

      if (itemSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('items')
            .doc(itemSnapshot.docs.first.id)  // Delete the document by ID
            .delete();

        _items.removeWhere((item) => item.name == name);  // Remove item locally
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to remove item: $error");
      }
    }
  }

  // Update an item in Firestore by name for the logged-in user
  Future<void> updateItem(Item item) async {
    try {
      final itemSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .where('name', isEqualTo: item.name)  // Find item by name
          .get();

      if (itemSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('items')
            .doc(itemSnapshot.docs.first.id)  // Update the document by ID
            .update({
          'name': item.name,
          'quantity': item.quantity,
          'unit': item.unit,
          'note': item.note,
          'nutrition': item.nutrition,
        });

        // Update the local list as well
        int index = _items.indexWhere((i) => i.name == item.name);
        if (index != -1) {
          _items[index] = item;  // Update item locally
          notifyListeners();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to update item: $error");
      }
    }
  }

  void sortItemsByName() {
    _items.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void sortItemsByQuantity() {
    _items.sort((a, b) => a.quantity.compareTo(b.quantity));
    notifyListeners();
  }
}
