import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.title});

  final String title;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: ItemProvider().items.length,
        itemBuilder: (context, index){
          final item = ItemProvider().items[index];
          return ListTile(
            title: Text(item.name, style: TextStyle(fontSize: 20)),
            subtitle: Text("Quantity: ${item.quantity} ${item.unit}", style: TextStyle(fontSize: 15)),
              onTap: () {
                context.go('/inventory/itemDetails/${item.name}');
              }
          );
        }
      ),
    );
  }
}
