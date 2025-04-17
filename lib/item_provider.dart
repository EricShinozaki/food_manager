import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:food_manager/main.dart';

class Item {
  String name;
  double quantity;
  String unit;
  String note;
  List<String> nutrition;
  DateTime? expirationDate; // New field for expiration date

  Item({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.note,
    this.nutrition = const [],
    this.expirationDate, // Add expirationDate to constructor
  });

  factory Item.fromFireStore(Map<String, dynamic> data) {
    return Item(
      name: data['name'],
      quantity: data['quantity'].toDouble(),
      unit: data['unit'],
      note: data['note'],
      nutrition: List<String>.from(data['nutrition']),
      expirationDate: data['expirationDate'] != null
          ? (data['expirationDate'] as Timestamp).toDate() // Convert Firestore Timestamp to DateTime
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'note': note,
      'nutrition': nutrition,
      'expirationDate': expirationDate != null ? Timestamp.fromDate(expirationDate!) : null, // Convert DateTime to Firestore Timestamp
    };
  }
}

class ItemProvider with ChangeNotifier {
  final FirebaseFirestore database = db;
  User? user;

  List<Item> _items = [];
  List<Item> get items => _items;

  ItemProvider() {
    // Listen for changes in user authentication state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user = user;
      // If the user is logged in, fetch their items
      if (user != null) {
        fetchItems();  // Optional: Fetch items when the user is logged in
      } else {
        _clearItems();  // Clear items if the user is logged out
      }
      notifyListeners();  // Notify listeners that the user state has changed
    });
  }

  Future<void> fetchItems() async {
    if (user == null) {
      if (kDebugMode) {
        print("User is not logged in.");
      }
      return;
    }

    try {
      _clearItems();
      final querySnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .get();

      _items = querySnapshot.docs.map((doc) {
        return Item.fromFireStore(doc.data());
      }).toList();

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Failed to fetch items: $error");
      }
    }
  }

  Future<String> addItem(Item item) async {
    if (user == null) {
      return "User is not logged in.";
    }

    try {
      final existingItemSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .where('name', isEqualTo: item.name)
          .get();

      if (existingItemSnapshot.docs.isEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('items')
            .add(item.toMap());

        _items.add(item);
        notifyListeners();
        return "Item added successfully";
      } else {
        if (kDebugMode) {
          print("Item with this name already exists");
        }
        return "Item with this name already exists";
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to add item: $error");
      }
      return "Failed to add item: $error";
    }
  }

  Future<void> removeItem(String name) async {
    if (user == null) {
      return;
    }

    try {
      final itemSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .where('name', isEqualTo: name)
          .get();

      if (itemSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('items')
            .doc(itemSnapshot.docs.first.id)
            .delete();

        _items.removeWhere((item) => item.name == name);
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to remove item: $error");
      }
    }
  }

  Future<void> updateItem(Item item) async {
    if (user == null) {
      return;
    }

    try {
      final itemSnapshot = await database
          .collection('users')
          .doc(user?.uid)
          .collection('items')
          .where('name', isEqualTo: item.name)
          .get();

      if (itemSnapshot.docs.isNotEmpty) {
        await database
            .collection('users')
            .doc(user?.uid)
            .collection('items')
            .doc(itemSnapshot.docs.first.id)
            .update(item.toMap());

        int index = _items.indexWhere((i) => i.name == item.name);
        if (index != -1) {
          _items[index] = item;
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

  void _clearItems() {
    _items = [];
    notifyListeners();
  }
}

